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
    case
    photos(
        type: PhotoListType,
        page: Int,
        perPage: Int,
        orderBy: OrderBy
    ),
    collections(
        type: CollectionListType,
        page: Int,
        perPage: Int
    ),
    collection(id: Int)
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
        }
    }

    var method: Moya.Method {
        switch self {
        case .photos, .collections, .collection:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .photos(_, let page, let perPage, let orderBy):
            return .requestParameters(parameters: [
                "page": page,
                "per_page": perPage,
                "order_by": orderBy.rawValue
                ], encoding: URLEncoding.default)
        case .collections(_, let page, let perPage):
            return .requestParameters(parameters: [
                "page": page,
                "per_page": perPage,
                ], encoding: URLEncoding.default)
        case .collection:
            return .requestPlain
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
