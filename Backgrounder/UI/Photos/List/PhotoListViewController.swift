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
//import BTNavigationDropdownMenu

final class PhotoListViewController: BaseViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    private lazy var layout = PhotoCollectionLayout.list
    private lazy var collectionView: UICollectionView = {
        let flowLayout = createCollectionLayout(type: layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(self.didToggleRefreshControl), for: .valueChanged)
        return r
    }()

    private lazy var leftBarButtonItem = UIBarButtonItem(title: "",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(didTapLeftBarButtonItem))
    private lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                          target: self,
                                                          action: #selector(didTapRightBarButtonItem))

    // MARK: - Properties
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

        refreshControl.sendActions(for: .valueChanged)
    }

    // MARK: - Private methods
    private func setupCollection() {
        leftBarButtonItem.title = layout.icon
/*
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
        }*/
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

        navigationItem.rightBarButtonItem = rightBarButtonItem

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


//        let menuView = BTNavigationDropdownMenu(navigationController: navigationController,
//                                                containerView: navigationController!.view,
//                                                title: viewModel.dropdownItem,
//                                                items: viewModel.dropdownItems)
//        menuView.applyDefaultStyle()
//
//        navigationItem.titleView = menuView
//        menuView.didSelectItemAtIndexHandler = { [weak self] index in
//            self?.viewModel.didSelectNavigationBarItem(at: index)
//        }
    }

    private func setupHero() {
        hero.isEnabled = true
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.actionCallback = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .stateDidUpdate(let state, _):
                DispatchQueue.main.async {
                    switch state.loadingState {
                    case .loading:
                        self.rightBarButtonItem.isEnabled = false
                    case .error(let error):
                        print(error)
                        self.rightBarButtonItem.isEnabled = true
                        self.refreshControl.endRefreshing()
                    case .default:
                        self.rightBarButtonItem.isEnabled = true
                        self.refreshControl.endRefreshing()
                    }

//                    self.collectionView.source = SimpleSource<PhotoViewData>(state.photos)
                    // TODO: Set data source for cv
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func didTapLeftBarButtonItem() {
        let layout = PhotoCollectionLayout(leftBarButtonItem.title ?? "")?.next ?? .list
        let flowLayout = createCollectionLayout(type: layout)

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        leftBarButtonItem.title = layout.icon
    }

    @objc private func didTapRightBarButtonItem() {
        viewModel.reload()
    }

    @objc private func didToggleRefreshControl() {
        viewModel.reload()
    }
}
