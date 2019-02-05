//
//  CircleIconButton.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 18/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit

final class CircleIconButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        layer.cornerRadius = layer.frame.width / 2
        layer.masksToBounds = true

        titleLabel?.font = Font.icon.withSize(25.0)
        titleLabel?.layer.masksToBounds = false

        titleLabel?.shadowColor = UIColor.black.withAlphaComponent(0.75)
        titleLabel?.shadowOffset = CGSize(width: 0, height: 2)

        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.25), for: .disabled)
        setTitleShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
    }

    var icon: String = "" {
        didSet {
            setTitle(icon, for: .normal)
        }
    }
}
