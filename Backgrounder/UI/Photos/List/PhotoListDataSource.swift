//
//  PhotoListDataSource.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import UIKit

final class PhotoListDataSource: NSObject, UICollectionViewDataSource {
    var photos: [PhotoViewData] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.data = photos[indexPath.row]
        return cell
    }
}
