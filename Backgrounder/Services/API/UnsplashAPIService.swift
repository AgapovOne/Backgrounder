//
//  UnsplashAPIService.swift
//  Backgrounder
//
//  Created by Alex Agapov on 10/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import RxSwift
import Moya

class UnsplashAPIService {
    func request<Model: Codable>(target: Unsplash, atKeyPath: String? = nil) -> Single<Model> {
        return Provider.default.rx
            .request(target)
            .map(Model.self, atKeyPath: atKeyPath)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
