//
//  PhotoCell.swift
//  Backgrounder
//
//  Created by Alex Agapov on 06/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher
import Hero

final class PhotoCell: UICollectionViewCell, NibReusable {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = Configuration.Size.padding
        imageView.layer.masksToBounds = true
    }

    var photo: PhotoViewData! {
        didSet {
            hero.isEnabled = true
            imageView.hero.id = photo.id
            nameLabel.hero.id = photo.heroLabelID

            imageView.kf.setImage(with: photo.regularPhotoURL,
                                  placeholder: UIImage.from(color: Configuration.Color.tintColor))
            nameLabel.text = photo.photoCopyright
        }
    }

    func cancelDownloadIfNeeded() {
        imageView.kf.cancelDownloadTask()
    }
}
