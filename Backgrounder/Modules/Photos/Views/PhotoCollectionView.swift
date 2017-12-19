//
//  PhotoCollectionView.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift

class PhotoCollectionView: UICollectionView {
    var layout: CollectionLayout = .list {
        didSet {
            setLayout(layout)
        }
    }

    var setRxLayout: AnyObserver<CollectionLayout>!
    var rxLayout: Observable<CollectionLayout>!

    private lazy var listLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .list)
    }()
    private lazy var halfGridLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .halfGrid)
    }()
    private lazy var oneOfThreeGridLayout: UICollectionViewFlowLayout = {
        return createCollectionLayout(type: .oneOfThreeGrid)
    }()

    private let padding: CGFloat = Configuration.Size.padding

    override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 11.0, *) {
            contentInset = safeAreaInsets
        } else {
            contentInset = UIEdgeInsets(top: layoutMargins.top, left: 0, bottom: 0, right: 0)
        }

        let _rxLayout = BehaviorSubject(value: CollectionLayout.list)

        setRxLayout = _rxLayout.asObserver()
        rxLayout = _rxLayout.do(onNext: { [weak self] in
            self?.layout = $0
        })
    }

    private func setLayout(_ type: CollectionLayout, animated: Bool = true) {
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
