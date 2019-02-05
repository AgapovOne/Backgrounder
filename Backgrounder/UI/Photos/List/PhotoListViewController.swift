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
        collectionView.delegate = self
        collectionView.dataSource = dataSource
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

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    private let dataSource = PhotoListDataSource()

    private var page = 1

    // MARK: Input from outside
    private var showPhoto: ((PhotoViewData) -> Void)?

    private var photoAPIService: PhotoAPIService!

    private var dropdownItem: String {
        return photoAPIService.photoListType.string
    }

    private var dropdownItems: [String] {
        return PhotoListType.all.map({ $0.string })
    }

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


        let menuView = BTNavigationDropdownMenu(navigationController: navigationController,
                                                containerView: navigationController!.view,
                                                title: dropdownItem,
                                                items: dropdownItems)
        menuView.applyDefaultStyle()

        navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = { [weak self] index in
            self?.didSelectNavigationBarItem(at: index)
        }
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

    @objc private func didToggleRefreshControl() {
        reload()
    }

    private func didSelectNavigationBarItem(at index: Int) {
        photoAPIService.photoListType = PhotoListType.all[index]
        reload()
    }

    // MARK: - Private
    private func reload() {
        page = 1
        load()
    }

    private func load() {
        photoAPIService
            .getPhotos(page: page)
            .observeOn(MainScheduler.instance)
            .subscribe({ (response) in
                switch response {
                case .success(let items):
                    if self.page == 1 {
                        self.dataSource.photos = items.map(PhotoViewData.init)
                    } else {
                        self.dataSource.photos += items.map(PhotoViewData.init)
                    }
                    self.collectionView.reloadData()
                case .error(let error):
                    print(error)
                }
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

    private func loadNext() {
        page += 1
        load()
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPhoto?(dataSource.photos[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataSource.photos.count - 1 {
            loadNext()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PhotoCell)?.cancelDownloadIfNeeded()
    }
}
