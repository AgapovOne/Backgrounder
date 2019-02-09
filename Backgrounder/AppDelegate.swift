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
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = appCoordinator.toPresentable()
        window?.makeKeyAndVisible()

        appCoordinator.start()

        setupAppearance()
        setupLibraries()

        return true
    }

    // MARK: - Private
    private func setupAppearance() {
        let tint = Configuration.Color.tint
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = tint
        navBar.tintColor = .white
        navBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: Font.navbarTitle
        ]

        let tabBar = UITabBar.appearance()
        tabBar.barStyle = .black
        tabBar.barTintColor = tint
        tabBar.isTranslucent = true
        tabBar.unselectedItemTintColor = Configuration.Color.gray
        tabBar.tintColor = .white

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]

        let window = UIWindow.appearance()
        window.backgroundColor = Configuration.Color.darkGray
        window.tintColor = tint
    }

    private func setupLibraries() {
        NetworkActivityIndicatorManager.shared.isEnabled = true

        KingfisherManager.shared.defaultOptions = [.transition(.fade(0.2))]
    }
}
