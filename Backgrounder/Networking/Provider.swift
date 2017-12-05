//
//  Provider.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Moya

struct Provider {
    static let `default` = MoyaProvider<Unsplash>()
}
