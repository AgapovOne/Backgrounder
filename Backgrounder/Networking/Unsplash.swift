//
//  Unsplash.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Moya

enum OrderBy: String {
    case latest, oldest, popular
}

enum Unsplash {
    case photos(
        type: PhotoListType,
        page: Int,
        perPage: Int,
        orderBy: OrderBy
    )
    case collections(
        type: CollectionListType,
        page: Int,
        perPage: Int
    )
    case collection(id: Int)
    case collectionPhotos(
        id: Int,
        page: Int,
        perPage: Int
    )
    case searchPhotos(
        query: String,
        page: Int,
        perPage: Int,
        collections: [Int]
    )
    case searchCollections(
        query: String,
        page: Int,
        perPage: Int
    )
}

extension Unsplash: TargetType {
    var baseURL: URL { return URL(string: "https://api.unsplash.com")! }

    var path: String {
        switch self {
        case .photos(let type, _, _, _):
            switch type {
            case .curated:
                return "/photos/curated"
            case .new:
                return "/photos"
            }
        case .collections(let type, _, _):
            switch type {
            case .featured:
                return "/collections/featured"
            case .curated:
                return "/collections/curated"
            case .new:
                return "/collections"
            }
        case .collection(let id):
            return "/collection/\(id)"
        case .collectionPhotos(id: let id, _, _):
            return "/collections/\(id)/photos"
        case .searchPhotos:
            return "/search/photos"
        case .searchCollections:
            return "/search/collections"
        }
    }

    var method: Moya.Method {
        switch self {
        case .photos, .collections, .collection, .collectionPhotos, .searchPhotos, .searchCollections:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .photos(_, let page, let perPage, let orderBy):
            return .requestParameters(parameters: ["page": page,
                                                   "per_page": perPage,
                                                   "order_by": orderBy.rawValue
                ],
                                      encoding: URLEncoding.default)
        case .collections(_, let page, let perPage):
            return .requestParameters(parameters: ["page": page,
                                                   "per_page": perPage
                ],
                                      encoding: URLEncoding.default)
        case .collection:
            return .requestPlain
        case .collectionPhotos(_, let page, let perPage):
            return .requestParameters(parameters: ["page": page,
                                                   "per_page": perPage
                ],
                                      encoding: URLEncoding.default)
        case .searchCollections(let query, let page, let perPage):
            return .requestParameters(parameters: ["query": query,
                                                   "page": page,
                                                   "per_page": perPage
                ],
                                      encoding: URLEncoding.default)
        case .searchPhotos(let query, let page, let perPage, let collections):
            return .requestParameters(parameters: ["query": query,
                                                   "page": page,
                                                   "per_page": perPage,
                                                   "collections": collections
                ],
                                      encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return [
            "Content-type": "application/json",
            "Accept-Version": "v1",
            "Authorization": "Client-ID \(Configuration.API.unsplashApplicationID)"
        ]
    }
}
