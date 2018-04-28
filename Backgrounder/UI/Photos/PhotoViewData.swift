//
//  PhotoViewData.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 16/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

struct PhotoViewData: CellViewData, Hashable {

    private let photo: Photo

    var id: String {
        return photo.id
    }

    var heroID: String {
        return id
    }

    var heroLabelID: String {
        return "label\(photo.id)"
    }

    var fullPhotoURL: URL {
        return photo.urls.full
    }

    var regularPhotoURL: URL {
        return photo.urls.regular
    }

    var photoCopyright: String {
        return "photo by \(photo.user.username) (\(photo.user.name))"
    }

    var color: UIColor {
        return UIColor(hex: photo.color)
    }

    init(_ photo: Photo) {
        self.photo = photo
    }
}
