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

final class PhotoListViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    @IBOutlet private var collectionView: PhotoCollectionView! {
        didSet {
            collectionView.register(cellType: PhotoCell.self)
        }
    }
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
        setupViewModel()

        refreshControl.sendActions(for: .valueChanged)
    }

    // MARK: - Private methods
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl

        navigationItem.rightBarButtonItem = rightBarButtonItem

        [UIControlState.normal, UIControlState.focused, UIControlState.highlighted].forEach({
            leftBarButtonItem.setTitleTextAttributes([
                NSAttributedStringKey.font: Font.icon
                ], for: $0)
        })
        navigationItem.leftBarButtonItem = leftBarButtonItem

        leftBarButtonItem.title = collectionView.layout.icon
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.actionCallback = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .stateDidUpdate(let state, let prevState):
                self.navigationItem.title = state.title

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

                let changes = diff(old: prevState?.photos ?? [], new: state.photos)

                self.collectionView.reload(changes: changes, section: 0, completion: { _ in })
            }
        }
    }

    // MARK: - Actions
    @objc private func didTapLeftBarButtonItem() {
        let layout = CollectionLayout(leftBarButtonItem.title ?? "")?.next ?? .list

        collectionView.layout = layout
        leftBarButtonItem.title = layout.icon
    }

    @objc private func didTapRightBarButtonItem() {
        viewModel.reload()
    }

    @objc private func didToggleRefreshControl() {
        viewModel.reload()
    }
}

extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
}
