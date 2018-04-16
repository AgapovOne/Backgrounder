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

    override init(router: RouterType) {
        super.init(router: router)
        let vm = PhotoListViewModel(title: "Latest")
        let vc = PhotoListViewController.instantiate(viewModel: vm)
        vm.showPhoto = { [weak self] photo in
            self?.showPhotoDetail(photo)
        }
        router.setRootModule(vc, hideBar: false)
    }

    private func showPhotoDetail(_ photo: Photo) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.present(vc)
    }

}
