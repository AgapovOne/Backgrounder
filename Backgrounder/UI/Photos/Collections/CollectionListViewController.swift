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

class CollectionListViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI
    private var collectionView: CollectionView<PhotoCollectionCell, SimpleSource<CollectionViewData>>!
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(self.didToggleRefreshControl), for: .valueChanged)
        return r
    }()

    // MARK: - Properties
    private var viewModel: CollectionListViewModel!

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
        let layout = UICollectionViewFlowLayout()
        let padding = Configuration.Size.padding
        let side = Configuration.Size.screenWidth - padding * 2 * 2
        layout.estimatedItemSize = CGSize(width: side, height: (side - padding * 2) / 2 + 60)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding * 2,
                                           left: padding * 2,
                                           bottom: padding * 2,
                                           right: padding * 2)

        collectionView = CollectionView<PhotoCollectionCell, SimpleSource<CollectionViewData>>(frame: .zero, layout: layout)
        collectionView.useDiffs = true

        collectionView.configureCell = { [weak self] cell, indexPath in
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
        }
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

        viewModel.actionCallback = { [weak self] action in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                switch action {
                case .stateDidUpdate(let state, let prevState):
                    DispatchQueue.main.async {
                        self.navigationItem.title = state.title

                        switch state.loadingState {
                        case .loading:
                            break
                        case .error(let error):
                            print(error)
                            self.refreshControl.endRefreshing()
                        case .default:
                            self.refreshControl.endRefreshing()
                        }

                        self.collectionView.source = SimpleSource<CollectionViewData>(state.collections)
                    }
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func didToggleRefreshControl() {
        viewModel.reload()
    }
}
