//
//  Layout.swift
//  Backgrounder
//
//  Created by Alex Agapov on 11/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

// Double padding at leading/trailing
func countLayout(width: CGFloat, padding: CGFloat, itemsPerRow: CGFloat) -> CGFloat {
    return (width - (padding * (itemsPerRow + 3))) / itemsPerRow
}
