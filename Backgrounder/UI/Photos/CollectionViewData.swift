//
//  CollectionViewData.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 03/05/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

struct CollectionViewData: Hashable {

    private let collection: Collection

    var id: String {
        return "\(collection.id)"
    }

    var heroID: String {
        return id
    }

//    var heroLabelID: String {
//        return "label\(collection.id)"
//    }

//    var coverFullPhotoURL: URL? {
//        return collection.coverPhoto?.urls.full
//    }

    var coverRegularPhotoURL: URL? {
        return collection.coverPhoto?.urls.regular
    }

    var title: String {
        return collection.title
    }

    var description: String? {
        return collection.description
    }

    var coverRegularPhotoColor: UIColor {
        return UIColor(hex: collection.coverPhoto?.color ?? "")
    }

    init(_ collection: Collection) {
        self.collection = collection
    }
}
