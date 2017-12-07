//
//  AppDelegate.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window?.rootViewController = UINavigationController(rootViewController: PhotosViewController.instantiate())

        setupAppearance()
        
        return true
    }

    private func setupAppearance() {
        window?.tintColor = .white
        
        print(UIFont.familyNames)
        let flatBlack = Configuration.tintColor
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = flatBlack
        navBar.tintColor = .white
        navBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Avenir Next", size: 18.0)!
        ]
    }
}
