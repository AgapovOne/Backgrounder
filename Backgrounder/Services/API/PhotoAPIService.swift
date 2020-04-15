//
//  PhotoAPIService.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import RxSwift
import Moya

final class PhotoAPIService: UnsplashAPIService {

    var photoListType = Defaults.photoListType {
        didSet {
            Defaults.photoListType = self.photoListType
        }
    }

    func getPhotos(page: Int, orderBy: OrderBy = .latest) -> Single<[Photo]> {
        request(target: .photos(type: photoListType, page: page, perPage: Configuration.Defaults.pagination, orderBy: orderBy))
    }

    func getCollectionPhotos(id: Int, page: Int) -> Single<[Photo]> {
        request(target: .collectionPhotos(id: id, page: page, perPage: Configuration.Defaults.pagination))
    }

    func searchPhotos(page: Int, query: String, collections: [Int] = []) -> Single<[Photo]> {
        request(target: .searchPhotos(query: query,
                                             page: page,
                                             perPage: Configuration.Defaults.pagination,
                                             collections: collections),
                       atKeyPath: "results")
    }
}
