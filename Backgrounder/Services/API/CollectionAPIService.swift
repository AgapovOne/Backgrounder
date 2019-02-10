//
//  CollectionAPIService.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import RxSwift

final class CollectionAPIService: UnsplashAPIService {

    var collectionListType = Defaults.collectionListType {
        didSet {
            Defaults.collectionListType = self.collectionListType
        }
    }

    func getCollections(page: Int) -> Single<[UnsplashCollection]> {
        return request(target: .collections(type: collectionListType, page: page, perPage: Configuration.Defaults.pagination))
    }

    func getCollection(id: Int) -> Single<UnsplashCollection> {
        return request(target: .collection(id: id))
    }

    func searchCollections(page: Int, query: String) -> Single<[UnsplashCollection]> {
        return request(target: .searchCollections(query: query, page: page, perPage: Configuration.Defaults.pagination),
                       atKeyPath: "results")
    }
}
