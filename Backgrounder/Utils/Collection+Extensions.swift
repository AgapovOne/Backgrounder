//
//  Collection+Extensions.swift
//  Backgrounder
//
//  Created by Alex Agapov on 09/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import Foundation

extension Swift.Collection {
    var nonEmpty: Self? {
        return isEmpty ? nil : self
    }
}
