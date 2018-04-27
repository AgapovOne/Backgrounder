//
//  PhotosCoordinator.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Hero

class PhotosCoordinator: Coordinator<DeepLink> {
    // MARK: - Declarations
    enum StartPoint {
        case photos(type: PhotoListType)
        case collections(type: CollectionListType)
    }

    init(router: RouterType, title: String, startPoint: StartPoint) {
        super.init(router: router)

        let vc: UIViewController
        switch startPoint {
        case .collections(let type):
            let vm = CollectionViewModel(title: title, collectionAPIService: CollectionAPIService(type: type))
            vc = CollectionViewController.instantiate(viewModel: vm)
        case .photos(let type):
            let vm = PhotoListViewModel(title: title, photoAPIService: PhotoAPIService(type: type))
            vc = PhotoListViewController.instantiate(viewModel: vm)
            vm.showPhoto = { [weak self] photo in
                self?.showPhotoDetail(photo)
            }
        }
        router.setRootModule(vc, hideBar: false)
    }

    private func showPhotoDetail(_ photo: PhotoViewData) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.present(vc)
    }

}
