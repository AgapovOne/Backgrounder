//
//  PhotoAPIService.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import RxSwift

final class PhotoAPIService {

    var photoListType = Defaults.photoListType {
        didSet {
            Defaults.photoListType = self.photoListType
        }
    }

    func getPhotos(page: Int, orderBy: OrderBy = .latest) -> Single<[Photo]> {
        return Provider.default.rx
            .request(.photos(type: photoListType, page: page, perPage: Configuration.Defaults.pagination, orderBy: orderBy))
            .map(Array<Photo>.self)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }

    func getCollectionPhotos(id: Int, page: Int) -> Single<[Photo]> {
        return Provider.default.rx
            .request(.collectionPhotos(id: id, page: page, perPage: Configuration.Defaults.pagination))
            .map(Array<Photo>.self)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }

    func searchPhotos(page: Int, query: String, collections: [Int] = []) -> Single<[Photo]> {
        return Provider.default.rx
            .request(.searchPhotos(query: query, page: page, perPage: Configuration.Defaults.pagination, collections: collections))
            .map(Array<Photo>.self, atKeyPath: "results")
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
