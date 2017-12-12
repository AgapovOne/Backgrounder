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
    private lazy var control = UIRefreshControl()

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    private var viewModel: PhotosViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Lifecycle
    static func instantiate(viewModel: PhotosViewModel) -> PhotosViewController {
        let vc = PhotosViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        title = "Latest"
        
        collectionView.refreshControl = control
    }
    
    private func setupViewModel() {
        viewModel.repositories
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.control.endRefreshing()
            })
            .subscribe() { photos in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }
            .disposed(by: disposeBag)
        
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        item.rx.tap
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = item
    }
}

// MARK: - Collection view
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.photo = viewModel.photos.value[indexPath.row]
        return cell
    }
}
