//
//  Fonts.swift
//  Backgrounder
//
//  Created by Alex Agapov on 14/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import SwiftIconFont

enum Font {
    enum Icons {
        static let list = String.fontThemifyIcon("view.list")!
        static let grid2 = String.fontThemifyIcon("layout.grid2")!
        static let grid3 = String.fontThemifyIcon("layout.grid3")!

        static let close = String.fontThemifyIcon("close")!
        static let download = String.fontThemifyIcon("download")!
        static let share = String.fontThemifyIcon("share")!
    }

    static let icon = UIFont.icon(from: .themify, ofSize: 15.0)

//    static let heading1 = UIFont(FontName.avenirNext, size: 24.0)
//    static let heading2 = UIFont(FontName.avenirNext, size: 20.0)
    static let text = UIFont(FontName.avenirNext, size: 15.0)
    static let navbarTitle = UIFont(FontName.avenirNextMedium, size: 18.0)
    static let navbarLargeTitle = UIFont(FontName.avenirNextBold, size: 34.0)
}

private enum FontName: String {
    case avenirNextUltraLight = "AvenirNext-UltraLight"
    case avenirNext = "AvenirNext-Regular"
    case avenirNextMedium = "AvenirNext-Medium"
    case avenirNextBold = "AvenirNext-Bold"
    case avenirNextHeavy = "AvenirNext-Heavy"
}

private extension UIFont {
    convenience init(_ fontName: FontName, size: CGFloat) {
        self.init(name: fontName.rawValue, size: size)!
    }
}
