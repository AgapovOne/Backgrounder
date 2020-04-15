//
//  CollectionListType.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

enum CollectionListType {
    case
    new,
    featured,
    curated

    static var all: [CollectionListType] { [.new, .featured, .curated] }

    var string: String {
        switch self {
        case .new:
            return "New"
        case .featured:
            return "Featured"
        case .curated:
            return "Popular"
        }
    }

    init(_ value: String) {
        switch value {
        case CollectionListType.new.string:
            self = .new
        case CollectionListType.featured.string:
            self = .featured
        case CollectionListType.curated.string:
            self = .curated
        default:
            self = .new
        }
    }
}
