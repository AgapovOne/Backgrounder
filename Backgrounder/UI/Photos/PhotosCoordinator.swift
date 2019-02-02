//
//  PhotosCoordinator.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Hero
import RxSwift

class PhotosCoordinator: Coordinator<DeepLink> {
    // MARK: - Declarations
    enum StartPoint {
        case photos
        case collections
    }

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    init(router: RouterType, title: String, startPoint: StartPoint) {
        super.init(router: router)

        let vc: UIViewController
        switch startPoint {
        case .collections:
            let vm = CollectionListViewModel(title: title, collectionAPIService: CollectionAPIService())
            vc = CollectionListViewController.instantiate(viewModel: vm)
            vm.showCollection.subscribe(onNext: { _ in
                // TODO: Show collection details
            })
        case .photos:
            vc = PhotoListViewController.instantiate(photoAPIService: PhotoAPIService(),
                                                     showPhoto: { [weak self] photo in
                self?.showPhotoDetail(photo)
            })
        }
        router.setRootModule(vc, hideBar: false)
    }

    // MARK: - Private
    private func showPhotoDetail(_ photo: PhotoViewData) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.present(vc)
    }

}
