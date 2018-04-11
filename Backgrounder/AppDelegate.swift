//
//  AppDelegate.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

import AlamofireNetworkActivityIndicator
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rootController: UINavigationController {
        return self.window!.rootViewController as! UINavigationController
    }

    private lazy var appCoordinator: Coordinator = self.makeCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window?.rootViewController = UINavigationController()

        appCoordinator.start()

        setupAppearance()
        setupLibraries()

        return true
    }

    // MARK: - Private
    private func makeCoordinator() -> Coordinator {
        return AppCoordinator(
            router: RouterImp(rootController: self.rootController)
        )
    }

    private func setupAppearance() {
        let tint = Configuration.Color.tintColor
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = .white
        navBar.tintColor = tint
        navBar.titleTextAttributes = [
            .foregroundColor: tint,
            .font: Font.navbarTitle
        ]
        if #available(iOS 11.0, *) {
            navBar.prefersLargeTitles = true
            navBar.largeTitleTextAttributes = [
                .foregroundColor: tint,
                .font: Font.navbarLargeTitle
            ]
        }

        window?.tintColor = tint
    }

    private func setupLibraries() {
        NetworkActivityIndicatorManager.shared.isEnabled = true

        KingfisherManager.shared.defaultOptions = [.transition(.fade(0.2))]
    }
}
