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
//import BTNavigationDropdownMenu

final class PhotoListViewController: BaseViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    private lazy var layout = PhotoCollectionLayout.list
    private lazy var collectionView: UICollectionView = {
        let flowLayout = createCollectionLayout(type: layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: PhotoCell.self)
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
    private let disposeBag = DisposeBag()

    private var page = 1
    private var photos: [PhotoViewData] = []

    // MARK: Input from outside
    private var showPhoto: ((PhotoViewData) -> Void)?

    private var photoAPIService: PhotoAPIService!

    // MARK: - Lifecycle
    static func instantiate(photoAPIService: PhotoAPIService, showPhoto: ((PhotoViewData) -> Void)?) -> PhotoListViewController {
        let vc = PhotoListViewController.instantiate()
        vc.photoAPIService = photoAPIService
        vc.showPhoto = showPhoto
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

    }

    // MARK: - Actions
    @objc private func didTapLeftBarButtonItem() {
        let layout = PhotoCollectionLayout(leftBarButtonItem.title ?? "")?.next ?? .list
        let flowLayout = createCollectionLayout(type: layout)

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        leftBarButtonItem.title = layout.icon
    }

    @objc private func didTapRightBarButtonItem() {
        reload()
    }

    @objc private func didToggleRefreshControl() {
        reload()
    }

    // MARK: Inputs
    func didSelectNavigationBarItem(at index: Int) {
        photoAPIService.photoListType = PhotoListType.all[index]
        reload()
    }

    func reload() {
        page = 1
        load()
    }

    // MARK: Outputs
    var dropdownItem: String {
        return photoAPIService.photoListType.string
    }

    var dropdownItems: [String] {
        return PhotoListType.all.map({ $0.string })
    }

    // MARK: - Private
    private func load() {
        rightBarButtonItem.isEnabled = false
        photoAPIService
            .getPhotos(page: page)
            .observeOn(MainScheduler.instance)
            .subscribe({ (response) in
                switch response {
                case .success(let items):
                    if self.page == 1 {
                        self.photos = items.map(PhotoViewData.init)
                    } else {
                        self.photos += items.map(PhotoViewData.init)
                    }
                    self.collectionView.reloadData()
                case .error(let error):
                    print(error)
                }
                self.rightBarButtonItem.isEnabled = true
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    private func loadNext() {
        page += 1
        load()
    }

}

extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.data = photos[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPhoto?(photos[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            loadNext()
        }
    }
}
