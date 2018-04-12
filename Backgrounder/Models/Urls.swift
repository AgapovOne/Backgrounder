//
//  Urls.swift
//  Backgrounder
//
//  Created by Alex Agapov on 07/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation

struct Urls: Codable, Equatable {
    let raw: URL
    let thumb: URL
    let small: URL
    let regular: URL
    let full: URL
}
