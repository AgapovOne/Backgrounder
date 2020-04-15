//
//  CollectionViewData.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 03/05/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

struct CollectionViewData: Hashable {

    let collection: UnsplashCollection

    var id: String {
        "\(collection.id)"
    }

    var heroID: String {
        id
    }

//    var heroLabelID: String {
//        return "label\(collection.id)"
//    }

//    var coverFullPhotoURL: URL? {
//        return collection.coverPhoto?.urls.full
//    }

    var coverRegularPhotoURL: URL? {
        collection.coverPhoto?.urls.regular
    }

    var title: String {
        collection.title.nonEmpty ?? "Unknown"
    }

    var description: String? {
        collection.description
    }

    var coverRegularPhotoColor: UIColor {
        UIColor(hex: collection.coverPhoto?.color ?? "")
    }

    init(_ collection: UnsplashCollection) {
        self.collection = collection
    }
}
