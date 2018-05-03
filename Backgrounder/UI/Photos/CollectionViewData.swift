//
//  CollectionViewData.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 03/05/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

struct CollectionViewData: CellViewData, Hashable {

    private let collection: Collection

    var id: String {
        return "\(collection.id)"
    }

    var heroID: String {
        return id
    }

    var heroLabelID: String {
        return "label\(collection.id)"
    }

//    var fullPhotoURL: URL {
//        return collection.urls.full
//    }
//
//    var regularPhotoURL: URL {
//        return collection.urls.regular
//    }
//
//    var photoCopyright: String {
//        return "photo by \(collection.user.username) (\(collection.user.name))"
//    }
//
//    var color: UIColor {
//        return UIColor(hex: collection.color)
//    }

    init(_ collection: Collection) {
        self.collection = collection
    }
}
