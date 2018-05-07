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

final class PhotoCollectionCell: UICollectionViewCell, ConfigurableCell {
    typealias VD = CollectionViewData

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textContainerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        textContainerView.layer.cornerRadius = Configuration.Size.padding
        textContainerView.layer.masksToBounds = true

        textContainerView.backgroundColor = Configuration.Color.gray
    }

    var data: VD? {
        didSet {
            guard let data = data else { return }
            hero.isEnabled = true
//            imageView.hero.id = data.heroID
//            nameLabel.hero.id = data.heroLabelID

            imageView.kf.setImage(with: data.coverRegularPhotoURL)
//                                  placeholder: UIImage.from(color: photo.color))
            titleLabel.text = data.title
            descriptionLabel.text = data.description
        }
    }

    func cancelDownloadIfNeeded() {
        imageView.kf.cancelDownloadTask()
    }
}
