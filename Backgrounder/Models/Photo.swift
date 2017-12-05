//
//  Photo.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id: String
    let description: String?
    let user: User
}

struct User: Codable {
    let id: String
    let username: String
    let name: String
}

struct Urls: Codable {
    let raw: URL
    let small: URL
    let thumb: URL
    let regular: URL
    let full: URL
}
