//
//  AppDelegate.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let initialViewController = PhotoListViewController.instantiate(viewModel: PhotoListViewModel(title: "Latest"))
        window?.rootViewController = UINavigationController(rootViewController: initialViewController)

        setupAppearance()
        setupLibraries()

        return true
    }

    private func setupAppearance() {
        let tint = Configuration.Color.tintColor
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = .white
        navBar.tintColor = tint
        navBar.titleTextAttributes = [
            .foregroundColor: tint,
            .font: UIFont(name: "Avenir Next", size: 18.0)!
        ]
        
        window?.tintColor = tint
    }

    private func setupLibraries() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}
