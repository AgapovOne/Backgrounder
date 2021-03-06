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

        nameLabel.textColor = .white
        nameLabel.shadowColor = Configuration.Color.textShadow
    }

    var data: PhotoViewData? {
        didSet {
            guard let data = data else { return }
            hero.isEnabled = true
            imageView.hero.id = data.heroID
            nameLabel.hero.id = data.heroLabelID

            imageView.kf.setImage(with: data.regularPhotoURL,
                                  placeholder: UIImage.from(color: data.color))
            nameLabel.text = data.photoCopyright
        }
    }

    func cancelDownloadIfNeeded() {
        imageView.kf.cancelDownloadTask()
    }
}
