//
//  UnsplashAPIService.swift
//  Backgrounder
//
//  Created by Alex Agapov on 10/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import RxSwift
import Moya
import Alamofire

class UnsplashAPIService {
    private enum ReachabilityError: Error, LocalizedError {
        case networkUnreachable

        var errorDescription: String? {
            switch self {
            case .networkUnreachable:
                return NSLocalizedString("Network is turned off. Check your connection.", comment: "Reachability error")
            }
        }
    }

    private let reachabilityManager = NetworkReachabilityManager()

    func request<Model: Codable>(target: Unsplash, atKeyPath: String? = nil) -> Single<Model> {
        if reachabilityManager?.isReachable == false {
            return Single.error(ReachabilityError.networkUnreachable)
        } else {
            return Provider.default.rx
                .request(target)
                .map(Model.self, atKeyPath: atKeyPath)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        }
    }
}
