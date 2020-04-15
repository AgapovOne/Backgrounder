//
//  PhotoListType.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

enum PhotoListType {
    case
    new,
    curated

    static var all: [PhotoListType] { [.new, .curated] }

    var string: String {
        switch self {
        case .new:
            return "New"
        case .curated:
            return "Popular"
        }
    }

    init(_ value: String) {
        switch value {
        case PhotoListType.new.string:
            self = .new
        case PhotoListType.curated.string:
            self = .curated
        default:
            self = .new
        }
    }
}
