//
//  Fonts.swift
//  Backgrounder
//
//  Created by Alex Agapov on 14/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import SwiftIconFont

enum Fonts {
    enum Icons {
        static let list = String.fontThemifyIcon("view.list")!
        static let grid2 = String.fontThemifyIcon("layout.grid2")!
        static let grid3 = String.fontThemifyIcon("layout.grid3")!
    }
    
    static let icon = UIFont.icon(from: .Themify, ofSize: 15.0)
}
