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

private let popularImage = UIImage(from: .Themify,
                                   code: "gallery",
                                   size: iconSize)
private let allImage = UIImage(from: .Themify,
                                   code: "layout.media.center.alt",
                                   size: iconSize)

enum TabBarConfiguration {
    enum Item {
        static let popular = UITabBarItem(title: "Popular",
                                          image: popularImage,
                                          selectedImage: popularImage)
        static let all = UITabBarItem(title: "All",
                                          image: allImage,
                                          selectedImage: allImage)
    }
}
