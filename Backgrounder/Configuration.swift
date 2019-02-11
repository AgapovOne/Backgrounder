//
//  Configuration.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Hue
import Keys

enum Configuration {
    enum API {
        static let unsplashApplicationID = BackgrounderKeys().unsplashAPIClientKey
    }

    enum Defaults {
        static let pagination = 30
    }

    enum Color {
        static let tint = UIColor(hex: "354960")
        static let gray = UIColor(hex: "7b8994")
        static let darkGray = UIColor(hex: "47525d")
        static let black = UIColor(hex: "3d464d")
        static let textShadow = UIColor(red: 71 / 255, green: 71 / 255, blue: 71 / 255, alpha: 1.0)
    }

    enum Size {
        static let screenWidth = UIScreen.main.bounds.width
        static let padding: CGFloat = 8
    }
}
