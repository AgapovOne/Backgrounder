//
//  CollectionListViewController.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import Cartography
import RxSwift
import RxCocoa
import RxOptional

final class CollectionListViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let padding = Configuration.Size.padding
        let side = Configuration.Size.screenWidth - padding * 2
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding,
                                           left: padding,
                                           bottom: padding,
                                           right: padding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

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

    // MARK: - Properties
    private var viewModel: CollectionListViewModel!

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    static func instantiate(viewModel: CollectionListViewModel) -> CollectionListViewController {
        let vc = CollectionListViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollection()
        setupUI()
        setupViewModel()
    }

    // MARK: - Private methods
    private func setupCollection() {
        collectionView.register(cellType: PhotoCollectionCell.self)
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

        view.backgroundColor = Configuration.Color.darkGray
        collectionView.backgroundColor = Configuration.Color.darkGray

        view.addSubview(activityIndicatorView)
        constrain(activityIndicatorView) { indicator in
            indicator.center == indicator.superview!.center
        }

        [statusLabel, errorDescriptionLabel].forEach {
            view.addSubview($0)
            constrain($0) { label in
                label.centerY == label.superview!.centerY
                label.leading == label.superview!.leading + 16
                label.trailing == label.superview!.trailing - 16
            }
        }

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.navbarLargeTitle
        ]
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        // Inputs
        collectionView.rx.modelSelected(CollectionViewData.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.select(item)
            })
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.deselectItem(at: indexPath, animated: true)
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

        refreshControl.rx.controlEvent(.valueChanged)
            .startWith(()) // Initial load
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

        // Outputs
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        let isLoading = viewModel.isLoading
            .asDriver(onErrorJustReturn: false)

        isLoading
            .filter({ [weak self] _ in
                guard let self = self else { return false }
                return self.collectionView.numberOfItems(inSection: 0) == 0
            })
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        isLoading
            .filter({ !$0 }) // Only stop refresh control, don't start it
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        let collectionsDriver = viewModel.collections
            .asDriver(onErrorJustReturn: [])

        collectionsDriver
            .drive(collectionView.rx.items(
                cellIdentifier: PhotoCollectionCell.reuseIdentifier,
                cellType: PhotoCollectionCell.self)
            ) { _, collection, cell in
                cell.data = collection
            }
            .disposed(by: disposeBag)

        let isEmptyDriver = collectionsDriver
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
}
