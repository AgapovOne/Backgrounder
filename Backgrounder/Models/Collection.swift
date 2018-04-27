//
//  Collection.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

struct Collection: Codable, Equatable {
    let id: String
    let title: String
    let description: String?
    let curated: Bool
    let featured: Bool
}

extension Collection: Hashable {
    var hashValue: Int { return id.hashValue }
}
