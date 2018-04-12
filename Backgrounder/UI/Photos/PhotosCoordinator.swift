//
//  PhotosCoordinator.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift

class PhotosCoordinator: Coordinator<DeepLink> {

    private let disposeBag = DisposeBag()

    override init(router: RouterType) {
        super.init(router: router)
        let vm = PhotoListViewModel(title: "Latest")
        let vc = PhotoListViewController.instantiate(viewModel: vm)
        vm.showPhoto
            .subscribe(onNext: { [weak self] photo in
                self?.showPhotoDetail(photo)
            })
            .disposed(by: disposeBag)
        router.setRootModule(vc, hideBar: false)
    }

    private func showPhotoDetail(_ photo: Photo) {
        let vc = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        router.push(vc)
    }

}
