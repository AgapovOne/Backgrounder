//
//  PhotoListViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import Cartography
import Kingfisher
import DeepDiff
import Moya
import RxSwift
import BTNavigationDropdownMenu

final class PhotoListViewController: BaseViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    private lazy var layout = PhotoCollectionLayout.list
    private lazy var collectionView: UICollectionView = {
        let flowLayout = createCollectionLayout(type: layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.register(cellType: PhotoCell.self)
        return collectionView
    }()
    private lazy var refreshControl = UIRefreshControl()

    private lazy var leftBarButtonItem = UIBarButtonItem(title: "",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(didTapLeftBarButtonItem))

    private let disposeBag = DisposeBag()
    private var viewModel: PhotoListViewModel!

    // MARK: - Lifecycle
    static func instantiate(viewModel: PhotoListViewModel) -> PhotoListViewController {
        let vc = PhotoListViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollection()
        setupUI()
        setupHero()
        setupViewModel()
    }

    // MARK: - Private methods
    private func setupCollection() {
        leftBarButtonItem.title = layout.icon
    }

    private func setupUI() {
        view.backgroundColor = Configuration.Color.darkGray
        collectionView.backgroundColor = Configuration.Color.darkGray

        collectionView.refreshControl = refreshControl

        if #available(iOS 11.0, *) {
            collectionView.contentInset = view.safeAreaInsets
        } else {
            collectionView.contentInset = UIEdgeInsets(top: view.layoutMargins.top, left: 0, bottom: 0, right: 0)
        }

        view.addSubview(collectionView)
        constrain(collectionView) { cv in
            cv.edges == cv.superview!.edges
        }

        [
            UIControl.State.normal,
            UIControl.State.focused,
            UIControl.State.highlighted
            ]
            .forEach({
                leftBarButtonItem.setTitleTextAttributes([
                    NSAttributedString.Key.font: Font.icon
                    ], for: $0)
            })
        navigationItem.leftBarButtonItem = leftBarButtonItem


        let menuView = BTNavigationDropdownMenu(navigationController: navigationController,
                                                containerView: navigationController!.view,
                                                title: viewModel.dropdownItem,
                                                items: viewModel.dropdownItems)
        menuView.applyDefaultStyle()

        navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = { [weak self] index in
            self?.didSelectNavigationBarItem(at: index)
        }
    }

    private func setupHero() {
        hero.isEnabled = true
    }

    private func setupViewModel() {
        // Inputs
        refreshControl.rx.controlEvent(.valueChanged)
            .startWith(())
            .subscribe(onNext: { [weak self] in
                self?.viewModel.reload()
            })
            .disposed(by: disposeBag)

        // Outputs
        viewModel.photos
            .asDriver { error in
                print(error)
                return .just([])
            }
            .drive(collectionView.rx.items(cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self)) { _, item, cell in
                cell.data = item
            }
            .disposed(by: disposeBag)

        let isLoading = viewModel.isLoading.asDriver(onErrorJustReturn: false)

        isLoading
            .filter({ $0 == false })
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    @objc private func didTapLeftBarButtonItem() {
        let layout = PhotoCollectionLayout(leftBarButtonItem.title ?? "")?.next ?? .list
        let flowLayout = createCollectionLayout(type: layout)

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        leftBarButtonItem.title = layout.icon
    }

    private func didSelectNavigationBarItem(at index: Int) {
        viewModel.selectNavigationType(at: index)
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.photos.value.count - 1 {
            viewModel.loadNext()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PhotoCell)?.cancelDownloadIfNeeded()
    }
}
