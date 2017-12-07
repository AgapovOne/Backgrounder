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
    let urls: Urls
    let width: Int
    let height: Int
}
