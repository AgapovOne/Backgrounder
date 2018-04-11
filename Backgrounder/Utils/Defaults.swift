//
//  Defaults.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 11/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

private let OnboardingWasShownKey = "OnboardingWasShownKey"
enum Defaults {
    static var onboardingWasShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: OnboardingWasShownKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: OnboardingWasShownKey)
        }
    }
}
