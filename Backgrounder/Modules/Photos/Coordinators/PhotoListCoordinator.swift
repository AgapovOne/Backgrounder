//
//  PhotoListCoordinator.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class PhotoListCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let viewModel = PhotoListViewModel(title: "Latest")
        let viewController = PhotoListViewController.instantiate(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: viewController)

        viewModel.showPhoto
            .subscribe(onNext: { [weak self] photo in
                self?.showPhoto(with: photo, in: navigationController)
            })
            .disposed(by: disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }

    private func showRepository(with photo: Photo, in navigationController: UINavigationController) {
        let photoVC = PhotoViewController.instantiate(viewModel: PhotoViewModel(photo: photo))
        navigationController.pushViewController(photoVC, animated: true)
    }
}
