//
//  PhotoAPIService.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import RxSwift

class PhotoAPIService {

    var photoListType: PhotoListType

    init(type: PhotoListType) {
        self.photoListType = type
    }

    func getPhotos(page: Int, orderBy: OrderBy = .latest) -> Single<[Photo]> {
        return Provider.default.rx
            .request(.photos(type: photoListType, page: page, perPage: Configuration.Defaults.pagination, orderBy: orderBy))
            .map(Array<Photo>.self)
    }
}

class CollectionAPIService {

    private let collectionListType: CollectionListType

    init(type: CollectionListType) {
        self.collectionListType = type
    }

    func getCollections(page: Int) -> Single<[Collection]> {
        return Provider.default.rx
            .request(.collections(type: collectionListType, page: page, perPage: Configuration.Defaults.pagination))
            .map(Array<Collection>.self)
    }

    func getCollection(id: Int) -> Single<Collection> {
        return Provider.default.rx
            .request(.collection(id: id))
            .map(Collection.self)
    }
}
