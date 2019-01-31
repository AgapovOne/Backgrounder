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

class CollectionListViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let padding = Configuration.Size.padding
        let side = Configuration.Size.screenWidth - padding * 2
        layout.itemSize = CGSize(width: side, height: (side - padding * 2) / 2 + 60)
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
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.isLoading
            .filter({ !$0 }) // Only stop refresh control, don't start it
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        let collectionsDriver = viewModel.collections
            .asDriver(onErrorJustReturn: [])

        collectionsDriver
            .drive(collectionView.rx.items(cellIdentifier: PhotoCollectionCell.reuseIdentifier, cellType: PhotoCollectionCell.self)) { _, collection, cell in
                cell.data = collection
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(CollectionViewData.self)
            .bind(to: viewModel.didSelectItem)
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell
            .bind(to: viewModel.willDisplayCell)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell
            .bind(to: viewModel.didEndDisplayingCell)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .startWith(()) // Initial load
            .bind(to: viewModel.load)
            .disposed(by: disposeBag)

        collectionView.rx.contentOffset
            .map { [weak self] _ in
                self?.collectionView.isNearBottomEdge(edgeOffset: startLoadingOffset) ?? false
            }
            .filter { $0 }
            .map { _ in () }
            .bind(to: viewModel.loadNext)
            .disposed(by: disposeBag)

        /*        collectionView.configureCell = { [weak self] cell, indexPath in
         self?.viewModel.configure(cell: cell, at: indexPath)
         }
         collectionView.didTapItem = { [weak self] indexPath in
         self?.viewModel.didSelectItem(at: indexPath)
         }
         collectionView.willDisplayCell = { [weak self] cell, indexPath in
         self?.viewModel.willDisplayCell(for: indexPath)
         }
         collectionView.didEndDisplayingCell = { cell, indexPath in
         cell.cancelDownloadIfNeeded()
         }*/
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

private let startLoadingOffset: CGFloat = 200.0
