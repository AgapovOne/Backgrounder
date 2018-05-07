//
//  PhotoCollectionView.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit

class PhotoCollectionView: UICollectionView {
    var layout: PhotoCollectionLayout = .list {
        didSet {
            setLayout(layout)
        }
    }

    private lazy var listLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .list)
    }()
    private lazy var halfGridLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .halfGrid)
    }()
    private lazy var oneOfThreeGridLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .oneOfThreeGrid)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()

        layout = .list
    }

    private func setLayout(_ type: PhotoCollectionLayout, animated: Bool = true) {
        var flowLayout: UICollectionViewFlowLayout
        switch type {
        case .list:
            flowLayout = listLayout
        case .halfGrid:
            flowLayout = halfGridLayout
        case .oneOfThreeGrid:
            flowLayout = oneOfThreeGridLayout
        }
        setCollectionViewLayout(flowLayout, animated: animated)
    }
}
