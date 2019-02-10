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
import Moya
import RxSwift
import RxCocoa
import RxOptional

final class PhotoListViewController: BaseViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    private lazy var collectionView: UICollectionView = {
        let flowLayout = createCollectionLayout(type: self.viewModel.layout.value)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: PhotoCell.self)
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()

    private lazy var photoTypeBarButtonItem = UIBarButtonItem(title: "",
                                                              style: .plain,
                                                              target: nil,
                                                              action: nil)
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

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Font.text
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.text
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
        }

        [statusLabel, errorDescriptionLabel].forEach {
            view.addSubview($0)
            constrain($0) { label in
                label.centerY == label.superview!.centerY
                label.leading == label.superview!.leading + 16
                label.trailing == label.superview!.trailing - 16
            }
        }

        [UIControl.State.normal,
         UIControl.State.focused,
         UIControl.State.highlighted,
         UIControl.State.disabled]
            .forEach({
                photoTypeBarButtonItem.setTitleTextAttributes([.font: Font.navbarItem], for: $0)
                layoutBarButtonItem.setTitleTextAttributes([.font: Font.icon], for: $0)
            })
        photoTypeBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.15),
                                                       .font: Font.navbarItem], for: .disabled)
        navigationItem.rightBarButtonItems = [layoutBarButtonItem, photoTypeBarButtonItem]

        navigationItem.title = viewModel.title

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

        photoTypeBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openAlertWithPhotoListType()
            })
            .disposed(by: disposeBag)

        layoutBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.updateLayout()
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
        let photosDriver = viewModel.photos
            .asDriver(onErrorJustReturn: [])

        photosDriver
            .drive(collectionView.rx.items(cellIdentifier: PhotoCell.reuseIdentifier, cellType: PhotoCell.self)) { _, item, cell in
                cell.data = item
            }
            .disposed(by: disposeBag)

        let isLoading = viewModel.isLoading.asDriver(onErrorJustReturn: false)

        isLoading
            .filter({ $0 == false })
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.query
            .map { query in
                query?.nonEmpty == nil
            }
            .asDriver(onErrorJustReturn: false)
            .drive(photoTypeBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.photoListTypeName
            .asDriver(onErrorJustReturn: "")
            .drive(photoTypeBarButtonItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.layout
            .map {
                $0.icon
            }
            .asDriver(onErrorJustReturn: "")
            .drive(layoutBarButtonItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.layout
            .map {
                createCollectionLayout(type: $0)
            }
            .subscribe(onNext: { [weak self] flowLayout in
                guard let self = self else { return }
                self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
            })
            .disposed(by: disposeBag)

        let isEmptyDriver = photosDriver
            .map({
                $0.isEmpty
            })


        let queryDriver = viewModel.query.asDriver(onErrorJustReturn: nil)
        Driver.combineLatest(isEmptyDriver, queryDriver)
            .filter({ isEmpty, query in
                (query?.nonEmpty != nil) && isEmpty
            })
            .map({ _, query in query })
            .filterNil()
            .map({ query in
                "Nothing found for \(query)"
            })
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)

        let errorDriver = viewModel.errorDescription
            .asDriver(onErrorJustReturn: nil)

        errorDriver
            .map({ $0 != nil })
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)

        errorDriver
            .map({ $0 == nil })
            .drive(errorDescriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)

        errorDriver
            .drive(errorDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        Driver.combineLatest(isEmptyDriver, errorDriver)
            .map({ isEmpty, error in
                if isEmpty && error == nil {
                    return false
                }
                return true
            })
            .drive(statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func openAlertWithPhotoListType() {
        let alert = UIAlertController(title: "How photos should be ordered", message: nil, preferredStyle: .actionSheet)
        for name in viewModel.photoListTypes {
            alert.addAction(UIAlertAction(title: name, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.selectPhotoType(name)
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
