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
    private lazy var refreshControl = UIRefreshControl()
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

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

        view.addSubview(collectionView)
        constrain(collectionView) { cv in
            cv.edges == cv.superview!.edges
        }

        view.backgroundColor = Configuration.Color.darkGray
        collectionView.backgroundColor = Configuration.Color.darkGray

        view.addSubview(activityIndicatorView)
        constrain(activityIndicatorView) { indicator in
            indicator.center == indicator.superview!.center
        }
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

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
    }
}
