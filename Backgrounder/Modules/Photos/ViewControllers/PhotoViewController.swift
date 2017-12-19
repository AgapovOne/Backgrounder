//
//  PhotoViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    private var viewModel: PhotoViewModel!

    // MARK: - Lifecycle
    static func instantiate(viewModel: PhotoViewModel) -> PhotoViewController {
        let vc = PhotoViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }

    // MARK: - Private methods
    private func setupUI() {
        authorLabel.font = Font.text
    }

    private func setupViewModel() {
        imageView.kf.setImage(with: viewModel.url)
    }
}
