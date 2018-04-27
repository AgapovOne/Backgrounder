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
    OnboardingWasShownKey,
    PhotoListTypeKey,
    CollectionListTypeKey
}

enum Defaults {
    static var onboardingWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DefaultsKey.OnboardingWasShownKey.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DefaultsKey.OnboardingWasShownKey.rawValue)
        }
    }

    static var photoListType: PhotoListType {
        get {
            return PhotoListType(UserDefaults.standard.string(forKey: DefaultsKey.PhotoListTypeKey.rawValue) ?? "")
        }
        set {
            UserDefaults.standard.set(newValue.string, forKey: DefaultsKey.PhotoListTypeKey.rawValue)
        }
    }

    static var collectionListType: CollectionListType {
        get {
            return CollectionListType(UserDefaults.standard.string(forKey: DefaultsKey.CollectionListTypeKey.rawValue) ?? "")
        }
        set {
            UserDefaults.standard.set(newValue.string, forKey: DefaultsKey.CollectionListTypeKey.rawValue)
        }
    }
}
