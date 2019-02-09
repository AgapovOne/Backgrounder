//
//  PhotoCollectionCell.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher
import Hero

final class PhotoCollectionCell: UICollectionViewCell, NibReusable {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        [imageView].forEach {
            $0?.layer.cornerRadius = Configuration.Size.padding
            $0?.layer.masksToBounds = true
        }
    }

    var data: CollectionViewData? {
        didSet {
            guard let data = data else { return }
            hero.isEnabled = true
//            imageView.hero.id = data.heroID
//            nameLabel.hero.id = data.heroLabelID

            imageView.kf.setImage(with: data.coverRegularPhotoURL,
                                  placeholder: UIImage.from(color: data.coverRegularPhotoColor))
            titleLabel.text = data.title
        }
    }

    func cancelDownloadIfNeeded() {
        imageView.kf.cancelDownloadTask()
    }
}
