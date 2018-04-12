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

    private lazy var appRouter: RouterType = Router(navigationController: UINavigationController())
    private lazy var appCoordinator: AppCoordinator = AppCoordinator(router: appRouter)

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = appCoordinator.toPresentable()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()

        appCoordinator.start()

        setupAppearance()
        setupLibraries()

        return true
    }

    // MARK: - Private
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
