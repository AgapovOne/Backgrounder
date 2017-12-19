//
//  PhotosNavigationController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 11/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

class PhotosNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {
    }
}
