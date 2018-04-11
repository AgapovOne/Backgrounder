//
//  PhotoListViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Kingfisher

final class PhotoListViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    @IBOutlet private var collectionView: PhotoCollectionView! {
        didSet {
            collectionView.register(cellType: PhotoCell.self)
        }
    }
    private lazy var refreshControl = UIRefreshControl()

    private lazy var leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    private lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)

    // MARK: - Properties
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

        setupUI()
        setupViewModel()

        refreshControl.sendActions(for: .valueChanged)
    }

    // MARK: - Private methods
    private func setupUI() {
        collectionView.refreshControl = refreshControl

        navigationItem.rightBarButtonItem = rightBarButtonItem

        [UIControlState.normal, UIControlState.focused, UIControlState.highlighted].forEach({
            leftBarButtonItem.setTitleTextAttributes([
                NSAttributedStringKey.font: Font.icon
                ], for: $0)
        })
        navigationItem.leftBarButtonItem = leftBarButtonItem

        leftBarButtonItem.rx.tap
            .map({ [weak self] in CollectionLayout(self?.leftBarButtonItem.title ?? "")?.next ?? .list })
            .bind(to: collectionView.setRxLayout)
            .disposed(by: disposeBag)

        collectionView.rxLayout
            .map({ $0.icon })
            .bind(to: leftBarButtonItem.rx.title)
            .disposed(by: disposeBag)
    }

    private func setupViewModel() {
        // ViewModel -> ViewController
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.photos
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: PhotoCell.self),
                                              cellType: PhotoCell.self)) { (_, photo, cell) in
                setupPhotoCell(cell, photo: photo)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map { state -> Bool in
                switch state {
                case .loading: return false
                default: return true
                }
            }
            .bind(to: rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)

        // ViewController -> ViewModel
        rightBarButtonItem.rx.tap
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(Photo.self)
            .bind(to: viewModel.selectPhoto)
            .disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell
            .subscribe(onNext: { item in
                guard let cell = item.cell as? PhotoCell else {
                    fatalError("Cell should be of type PhotoCell")
                }
                onEndDisplayingCell(cell)
            })
            .disposed(by: disposeBag)

    }
}

private func setupPhotoCell(_ cell: PhotoCell, photo: Photo) {
    cell.photo = photo
}

private func onEndDisplayingCell(_ cell: PhotoCell) {
    cell.cancelDownloadIfNeeded()
}
