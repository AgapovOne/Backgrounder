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
    static let sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet private var collectionView: PhotoCollectionView! {
        didSet {
            collectionView.register(cellType: PhotoCell.self)
        }
    }
    private lazy var control = UIRefreshControl()

    private let photos = Variable<[Photo]>([])
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photos.asObservable().subscribe { [weak self] event in
            self?.collectionView.reloadSections(IndexSet(integer: 0))
            self?.control.endRefreshing()
        }.disposed(by: disposeBag)
        
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = control
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

        refresh()
    }
    
    @objc private func refresh() {
        Provider.default.rx
            .request(.photos(page: 1))
            .map(Array<Photo>.self)
            .subscribe { (event) in
            switch event {
            case .error(let err):
                switch err as? MoyaError {
                case .underlying(let err, let res)?:
                    print((err, res))
                default:
                    print("Unknown error\n\n \(err)")
                }
                self.photos.value = []
            case .success(let result):
                self.photos.value = result
            }
        }.disposed(by: disposeBag)
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.photo = photos.value[indexPath.row]
        return cell
    }
}
