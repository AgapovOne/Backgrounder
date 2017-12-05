//
//  PhotosViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

final class PhotosViewController: UIViewController {

    @IBOutlet private var collectionView: PhotoCollectionView! {
        didSet {
            collectionView.register(cellType: PhotoCell.self)
        }
    }
    @IBOutlet private var refreshButton: UIButton!

    private let photos = Variable<[Photo]>([])
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photos.asObservable().subscribe { event in
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
        
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        refresh()
    }
    
    @objc private func refresh() {
        Provider.default.rx.request(.photos(page: 1))
            .debug()
            .map(Array<Photo>.self)
            .subscribe { (event) in
            switch event {
            case .error(let err):
                switch err as? MoyaError {
                case .underlying(let err, let res)?:
                    print("\(err), \(res)")
                default:
                    print("Unknown error\n\n \(err)")
                }
            case .success(let result):
                print("\(result)")
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
