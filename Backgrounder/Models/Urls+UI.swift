//
//  Urls+UI.swift
//  Backgrounder
//
//  Created by Alex Agapov on 07/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

private let size = UIScreen.main.scale * UIScreen.main.bounds.width

extension Urls {
    var thumbnail: URL { return raw.appendingPathComponent("?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=\(size)&fit=max") }
}
