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

    var coverFullPhotoURL: URL {
        return collection.coverPhoto.urls.full
    }

    var coverRegularPhotoURL: URL {
        return collection.coverPhoto.urls.regular
    }

    var title: String {
        return collection.title
    }

    var description: String {
//        return "photo by \(collection.user.username) (\(collection.user.name))"
        return collection.description ?? "~~~NO DESCRIPTION!!!~~~"
    }

//    var color: UIColor {
//        return UIColor(hex: collection.color)
//    }

    init(_ collection: Collection) {
        self.collection = collection
    }
}
