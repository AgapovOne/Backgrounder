//
//  PhotoCollectionLayout.swift
//  Backgrounder
//
//  Created by Alex Agapov on 11/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

enum PhotoCollectionLayout {
    case
    list,
    halfGrid,
    oneOfThreeGrid

    var icon: String {
        switch self {
        case .list:
            return Font.Icons.list
        case .halfGrid:
            return Font.Icons.grid2
        case .oneOfThreeGrid:
            return Font.Icons.grid3
        }
    }

    var itemsPerRow: CGFloat {
        switch self {
        case .list:
            return 1
        case .halfGrid:
            return 2
        case .oneOfThreeGrid:
            return 3
        }
    }

    var padding: CGFloat {
        return Configuration.Size.padding
    }

    var next: PhotoCollectionLayout {
        switch self {
        case .list:
            return .halfGrid
        case .halfGrid:
            return .oneOfThreeGrid
        case .oneOfThreeGrid:
            return .list
        }
    }

    init?(_ string: String) {
        switch string {
        case Font.Icons.list:
            self = .list
        case Font.Icons.grid2:
            self = .halfGrid
        case Font.Icons.grid3:
            self = .oneOfThreeGrid
        default:
            return nil
        }
    }
}

func createCollectionLayout(type: PhotoCollectionLayout,
                            width: CGFloat = Configuration.Size.screenWidth) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()

    let padding = type.padding
    let side = countSinglePaddingLayout(width: width, padding: padding, itemsPerRow: type.itemsPerRow)

    layout.itemSize = CGSize(width: side, height: side)
    layout.minimumInteritemSpacing = padding
    layout.minimumLineSpacing = padding
    layout.sectionInset = UIEdgeInsets(top: padding,
                                       left: padding,
                                       bottom: padding,
                                       right: padding)
    return layout
}

// Single padding at leading/trailing
func countSinglePaddingLayout(width: CGFloat, padding: CGFloat, itemsPerRow: CGFloat) -> CGFloat {
    return (width - (padding * (itemsPerRow + 1))) / itemsPerRow
}

// Double padding at leading/trailing
func countDoublePaddingLayout(width: CGFloat, padding: CGFloat, itemsPerRow: CGFloat) -> CGFloat {
    return (width - (padding * (itemsPerRow + 3))) / itemsPerRow
}
