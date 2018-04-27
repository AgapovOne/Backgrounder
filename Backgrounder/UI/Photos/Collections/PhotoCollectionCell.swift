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
    @IBOutlet private var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = Configuration.Size.padding
        imageView.layer.masksToBounds = true
    }

    var photo: Collection! {
        didSet {
//            hero.isEnabled = true
//            imageView.hero.id = photo.heroID
//            nameLabel.hero.id = photo.heroLabelID
//
//            imageView.kf.setImage(with: photo.regularPhotoURL,
//                                  placeholder: UIImage.from(color: photo.color))
//            nameLabel.text = photo.photoCopyright
        }
    }

    func cancelDownloadIfNeeded() {
        imageView.kf.cancelDownloadTask()
    }
}
