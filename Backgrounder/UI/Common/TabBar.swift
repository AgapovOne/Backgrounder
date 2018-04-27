//
//  TabBar.swift
//  Backgrounder
//
//  Created by Alex Agapov on 25/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit
import SwiftIconFont

private let side: CGFloat = 32
private let iconSize = CGSize(width: side, height: side)

private func image(code: String) -> UIImage {
    return UIImage(from: .Themify,
                   code: code,
                   size: iconSize)
}

private let popularImage = image(code: "image")
private let collectionImage = image(code: "gallery")
private let allImage = image(code: "layout.media.center.alt")

enum TabBarConfiguration {
    enum Item {
        static let popular = UITabBarItem(title: "Popular",
                                          image: popularImage,
                                          selectedImage: popularImage)
        static let collections = UITabBarItem(title: "Collections",
                                              image: collectionImage,
                                              selectedImage: collectionImage)
        static let all = UITabBarItem(title: "All",
                                          image: allImage,
                                          selectedImage: allImage)
    }
}
