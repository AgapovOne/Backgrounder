//
//  UnsplashCollection.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

struct UnsplashCollection: Codable, Equatable {
    let id: Int
    let title: String
    let description: String?
    let curated: Bool
    let featured: Bool
//    let urls: Urls
    let coverPhoto: Photo?

    enum CodingKeys: String, CodingKey {
        case id, title, description, curated, featured
//        case urls = "links"
        case coverPhoto = "cover_photo"
    }
}

extension UnsplashCollection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
