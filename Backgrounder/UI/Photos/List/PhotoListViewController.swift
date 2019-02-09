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
        collectionView.register(cellType: PhotoCell.self)
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()

    private lazy var layoutBarButtonItem = UIBarButtonItem(title: "",
                                                         style: .plain,
                                                         target: nil,
                                                         action: nil)

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.sizeToFit()

        searchController.searchBar.tintColor = .white
        return searchController
    }()

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
        layoutBarButtonItem.title = layout.icon
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

        collectionView.keyboardDismissMode = .interactive

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
                layoutBarButtonItem.setTitleTextAttributes([
                    NSAttributedString.Key.font: Font.icon
                    ], for: $0)
            })
        navigationItem.rightBarButtonItem = layoutBarButtonItem

        if viewModel.hasDropdownItems {
            let menuView = BTNavigationDropdownMenu(navigationController: navigationController,
                                                    containerView: navigationController!.view,
                                                    title: viewModel.dropdownItem,
                                                    items: viewModel.dropdownItems)
            menuView.applyDefaultStyle()

            navigationItem.titleView = menuView
            menuView.didSelectItemAtIndexHandler = { [weak self] index in
                self?.viewModel.selectNavigationType(at: index)
            }
        } else {
            navigationItem.title = viewModel.title
        }

        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.navbarLargeTitle
        ]
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

        let searchText = searchController.searchBar.rx.text.changed
            .throttle(0.8, scheduler: MainScheduler.instance)
            .distinctUntilChanged()

        searchText
            .bind(to: viewModel.query)
            .disposed(by: disposeBag)

        searchText
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.reload()
            })
            .disposed(by: disposeBag)

        layoutBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let layout = PhotoCollectionLayout(self.layoutBarButtonItem.title ?? "")?.next ?? .list
                let flowLayout = createCollectionLayout(type: layout)

                self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
                self.layoutBarButtonItem.title = layout.icon
            })
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(PhotoViewData.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.select(item)
            })
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                self?.viewModel.willDisplayCell(cell: cell, at: indexPath)
            })
            .disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                self?.viewModel.didEndDisplayingCell(cell: cell, indexPath: indexPath)
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
}

