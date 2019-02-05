//
//  CollectionAPIService.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import RxSwift

final class CollectionAPIService {

    var collectionListType = Defaults.collectionListType {
        didSet {
            Defaults.collectionListType = self.collectionListType
        }
    }

    func getCollections(page: Int) -> Single<[Collection]> {
        return Provider.default.rx
            .request(.collections(type: collectionListType, page: page, perPage: Configuration.Defaults.pagination))
            .filterSuccessfulStatusCodes()
            .map(Array<Collection>.self)
    }

    func getCollection(id: Int) -> Single<Collection> {
        return Provider.default.rx
            .request(.collection(id: id))
            .filterSuccessfulStatusCodes()
            .map(Collection.self)
    }
}
