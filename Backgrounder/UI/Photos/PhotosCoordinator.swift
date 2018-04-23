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

    init(router: RouterType, title: String, type: PhotoListType) {
        super.init(router: router)
        let vm = PhotoListViewModel(title: title, photoAPIService: PhotoAPIService(type: type))
        let vc = PhotoListViewController.instantiate(viewModel: vm)
        vm.showPhoto = { [weak self] photo in
            self?.showPhotoDetail(photo)
        }
        router.setRootModule(vc, hideBar: false)
    }

    private func showPhotoDetail(_ photo: PhotoViewData) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.present(vc)
    }

}
