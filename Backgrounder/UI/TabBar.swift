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
                                   textColor: .lightGray,
                                   size: iconSize).withRenderingMode(.alwaysOriginal)
private let popularImageSelected = UIImage(from: .Themify,
                                           code: "gallery",
                                           textColor: Configuration.Color.tintColor,
                                           size: iconSize).withRenderingMode(.alwaysOriginal)
private let allImage = UIImage(from: .Themify,
                                   code: "layout.media.center.alt",
                                   textColor: .lightGray,
                                   size: iconSize).withRenderingMode(.alwaysOriginal)
private let allImageSelected = UIImage(from: .Themify,
                                           code: "layout.media.center.alt",
                                           textColor: Configuration.Color.tintColor,
                                           size: iconSize).withRenderingMode(.alwaysOriginal)

enum TabBarConfiguration {
    enum Item {
        static let popular = UITabBarItem(title: "Popular",
                                          image: popularImage,
                                          selectedImage: popularImageSelected)
        static let all = UITabBarItem(title: "All",
                                          image: allImage,
                                          selectedImage: allImageSelected)
    }
}
