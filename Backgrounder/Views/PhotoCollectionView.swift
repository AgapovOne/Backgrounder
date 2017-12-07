//
//  PhotoCollectionView.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 11.0, *) {
            contentInset = safeAreaInsets
        } else {
            contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: width * 10/16)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        setCollectionViewLayout(layout, animated: false)
    }
}
