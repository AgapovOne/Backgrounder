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
import SwiftMessages
import Kingfisher

class PhotoViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!
    private lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)

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

    // MARK: - UI Actions
    // MARK: - Private methods
    private func setupUI() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.rightBarButtonItem = rightBarButtonItem

        authorLabel.font = Font.text
    }

    private func setupViewModel() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: viewModel.fullURL)
        authorLabel.text = viewModel.author

        // ViewModel -> ViewController
        viewModel.showDownloadResult
            .subscribe(onNext: { [weak self] isSucceeded in
                if isSucceeded {
                    self?.showSuccessMessage()
                }
            })
            .disposed(by: disposeBag)
        // ViewController -> ViewModel
        rightBarButtonItem.rx.tap
            .bind(to: viewModel.download)
            .disposed(by: disposeBag)
    }

    private func showSuccessMessage() {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.success)
        view.configureContent(title: "Saved", body: "Photo saved to your Camera Roll")
        SwiftMessages.show(view: view)
    }
}
