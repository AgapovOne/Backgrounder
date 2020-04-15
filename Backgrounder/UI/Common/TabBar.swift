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
    UIImage(from: .themify,
            code: code,
            size: iconSize)
}

private let photosImage = image(code: "image")
private let collectionImage = image(code: "gallery")

enum TabBarConfiguration {
    enum Item {
        static let photos = UITabBarItem(title: "Photos",
                                         image: photosImage,
                                         selectedImage: photosImage)
        static let collections = UITabBarItem(title: "Collections",
                                              image: collectionImage,
                                              selectedImage: collectionImage)
    }
}
