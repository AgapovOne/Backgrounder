//
//  PhotoViewData.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 16/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

struct PhotoViewData: Hashable {

    private let photo: Photo

    var id: String {
        photo.id
    }

    var heroID: String {
        id
    }

    var heroLabelID: String {
        "label\(photo.id)"
    }

    var fullPhotoURL: URL {
        photo.urls.full
    }

    var regularPhotoURL: URL {
        photo.urls.regular
    }

    var photoCopyright: String {
        "photo by \(photo.user.username) (\(photo.user.name))"
    }

    var color: UIColor {
        UIColor(hex: photo.color)
    }

    init(_ photo: Photo) {
        self.photo = photo
    }
}
