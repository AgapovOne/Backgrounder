//
//  PhotoListViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher
import DeepDiff
import BTNavigationDropdownMenu

final class PhotoListViewController: BaseViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    private var collectionView: CollectionView<PhotoCell, SimpleSource<PhotoViewData>>!
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

        setupUI()
        setupHero()
        setupViewModel()

        refreshControl.sendActions(for: .valueChanged)
    }

    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = Configuration.Color.darkGray
        collectionView.backgroundColor = Configuration.Color.darkGray

//        collectionView.delegate = self
//        collectionView.dataSource = self
        let layout = CollectionLayout.list
        let flowLayout = createCollectionLayout(type: layout)
        collectionView = CollectionView<PhotoCell, SimpleSource<PhotoViewData>>(frame: .zero, layout: flowLayout)
        collectionView.useDiffs = true
        collectionView.refreshControl = refreshControl

        if #available(iOS 11.0, *) {
            collectionView.contentInset = view.safeAreaInsets
        } else {
            collectionView.contentInset = UIEdgeInsets(top: view.layoutMargins.top, left: 0, bottom: 0, right: 0)
        }

        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        navigationItem.rightBarButtonItem = rightBarButtonItem

        [
            UIControlState.normal,
            UIControlState.focused,
            UIControlState.highlighted
        ]
            .forEach({
            leftBarButtonItem.setTitleTextAttributes([
                NSAttributedStringKey.font: Font.icon
                ], for: $0)
        })
        navigationItem.leftBarButtonItem = leftBarButtonItem

        leftBarButtonItem.title = layout.icon

        let menuView = BTNavigationDropdownMenu(navigationController: navigationController,
                                                containerView: navigationController!.view,
                                                title: viewModel.dropdownItem,
                                                items: viewModel.dropdownItems)
        menuView.applyDefaultStyle()

        navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = { [weak self] index in
            self?.viewModel.didSelectNavigationBarItem(at: index)
        }
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

//                    let changes = diff(old: prevState?.photos ?? [], new: state.photos)
//                    self.collectionView.reload(changes: changes, section: 0, completion: { _ in })

                    self.collectionView.source = SimpleSource<PhotoViewData>(state.photos)
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func didTapLeftBarButtonItem() {
        let layout = CollectionLayout(leftBarButtonItem.title ?? "")?.next ?? .list
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

/*extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        viewModel.configure(cell: cell, at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCell else {
            fatalError("Cell should be of type PhotoCell")
        }
        cell.cancelDownloadIfNeeded()
    }
}*/
