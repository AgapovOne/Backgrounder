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

final class PhotoCell: UICollectionViewCell, NibReusable {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView.layer.cornerRadius = Configuration.Size.padding
        imageView.layer.masksToBounds = true
    }

    var photo: Photo! {
        didSet {
            imageView.kf.setImage(with: photo.urls.regular)
            nameLabel.text = photo.user.name
        }
    }
}
