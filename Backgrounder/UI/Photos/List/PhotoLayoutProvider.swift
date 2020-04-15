//
//  PhotoLayoutProvider.swift
//  Backgrounder
//
//  Created by Alex Agapov on 10/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

class PhotoLayoutProvider {
    var value: PhotoCollectionLayout {
        get {
            Defaults.photoCollectionLayout
        }
        set {
            Defaults.photoCollectionLayout = newValue
        }
    }
}
