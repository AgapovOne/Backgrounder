//
//  Defaults.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 11/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

private enum DefaultsKey: String {
    case
    onboardingWasShownKey,
    photoListTypeKey,
    collectionListTypeKey,
    photoCollectionLayoutKey
}

enum Defaults {
    static var onboardingWasShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: DefaultsKey.onboardingWasShownKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DefaultsKey.onboardingWasShownKey.rawValue)
        }
    }

    static var photoListType: PhotoListType {
        get {
            PhotoListType(UserDefaults.standard.string(forKey: DefaultsKey.photoListTypeKey.rawValue) ?? "")
        }
        set {
            UserDefaults.standard.set(newValue.string, forKey: DefaultsKey.photoListTypeKey.rawValue)
        }
    }

    static var collectionListType: CollectionListType {
        get {
            CollectionListType(UserDefaults.standard.string(forKey: DefaultsKey.collectionListTypeKey.rawValue) ?? "")
        }
        set {
            UserDefaults.standard.set(newValue.string, forKey: DefaultsKey.collectionListTypeKey.rawValue)
        }
    }

    static var photoCollectionLayout: PhotoCollectionLayout {
        get {
            PhotoCollectionLayout(UserDefaults.standard.string(forKey: DefaultsKey.photoCollectionLayoutKey.rawValue) ?? "") ?? .list
        }
        set {
            UserDefaults.standard.set(newValue.icon, forKey: DefaultsKey.photoCollectionLayoutKey.rawValue)
        }
    }
}
