//
//  PhotoCollectionView.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView {
    private let itemsPerRow: CGFloat = 3
    private let padding: CGFloat = Configuration.Size.padding
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            contentInset = safeAreaInsets
        } else {
            contentInset = UIEdgeInsets(top: layoutMargins.top, left: 0, bottom: 0, right: 0)
        }
        
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let side = countLayout(width: screenWidth, padding: padding, itemsPerRow: itemsPerRow)
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding * 2,
                                           left: padding * 2,
                                           bottom: padding * 2,
                                           right: padding * 2)
        setCollectionViewLayout(layout, animated: false)
    }
}
