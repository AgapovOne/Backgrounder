//
//  Provider.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Moya

enum Provider {
    static let `default` = MoyaProvider<Unsplash>(plugins: [plugin])

    private static let plugin = NetworkActivityPlugin { change, _ in
        DispatchQueue.main.async {
            switch change {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
