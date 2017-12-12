//
//  PhotosViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Moya

final class PhotosViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)

    // MARK: - UI Outlets
    @IBOutlet private var collectionView: PhotoCollectionView! {
        didSet {
            collectionView.register(cellType: PhotoCell.self)
        }
    }
    private lazy var refreshControl = UIRefreshControl()

    private lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private var viewModel: PhotosViewModel!

    // MARK: - Lifecycle
    static func instantiate(viewModel: PhotosViewModel) -> PhotosViewController {
        let vc = PhotosViewController.instantiate()
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
            .bind(to: collectionView.rx.items(cellIdentifier: "PhotoCell", cellType: PhotoCell.self)) { [weak self] (_, photo, cell) in
                self?.setupPhotoCell(cell, photo: photo)
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
    }
    
    private func setupPhotoCell(_ cell: PhotoCell, photo: Photo) {
        cell.photo = photo
    }
}
