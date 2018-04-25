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

    private let photoListType: PhotoListType

    init(type: PhotoListType) {
        self.photoListType = type
    }

    func getPhotos(page: Int, orderBy: OrderBy = .latest) -> Single<[Photo]> {
        return Provider.default.rx
            .request(.photos(type: photoListType, page: page, perPage: 30, orderBy: orderBy))
            .map(Array<Photo>.self)
    }
}
