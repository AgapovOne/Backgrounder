//
//  PhotosCoordinator.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

class PhotosCoordinator: BaseCoordinator {

    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() {
        showPhotoList()
    }

    // MARK: - Run current flow's controllers
    private func showPhotoList() {

        let viewModel = PhotoListViewModel(title: "Latest")
        let vc = PhotoListViewController.instantiate(viewModel: viewModel)
//        vc.
//        itemsOutput.onItemSelect = { [weak self] (item) in
//            self?.showItemDetail(item)
//        }
        router.setRootModule(vc)
    }

    private func showPhotoDetail(_ photo: Photo) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.push(vc)
    }

    // MARK: - Run coordinators (switch to another flow)

//    private func runCreationFlow() {
//
//        let (coordinator, module) = coordinatorFactory.makeItemCreationCoordinatorBox()
//        coordinator.finishFlow = { [weak self, weak coordinator] item in
//
//            self?.router.dismissModule()
//            self?.removeDependency(coordinator)
//            if let item = item {
//                self?.showItemDetail(item)
//            }
//        }
//        addDependency(coordinator)
//        router.present(module)
//        coordinator.start()
//    }
}
