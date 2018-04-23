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

enum PhotoListType {
    case
    all,
    curated
}

enum Unsplash {
    case
    photos(
        type: PhotoListType,
        page: Int,
        perPage: Int,
        orderBy: OrderBy
    )
}

extension Unsplash: TargetType {
    var baseURL: URL { return URL(string: "https://api.unsplash.com")! }

    var path: String {
        switch self {
        case .photos(let type, _, _, _):
            if case .curated = type {
                return "/photos/curated"
            }
            return "/photos"
        }
    }

    var method: Moya.Method {
        switch self {
        case .photos:
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
