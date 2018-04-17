//
//  PhotoViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 19/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable
import SwiftMessages
import Kingfisher
import Hero

class PhotoViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI Outlets
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var closeButton: UIButton! {
        didSet {
            closeButton.titleLabel?.font = Font.icon
            closeButton.setTitle(Font.Icons.close, for: .normal)
            closeButton.setTitleShadowColor(UIColor.black.withAlphaComponent(0.5), for: .normal)
        }
    }
    private lazy var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                          target: self,
                                                          action: #selector(didTapSaveButton))

    // MARK: - Properties

    private var viewModel: PhotoViewModel!

    private var panGR: UIPanGestureRecognizer!

    // MARK: - Lifecycle
    static func instantiate(viewModel: PhotoViewModel) -> PhotoViewController {
        let vc = PhotoViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupHero()
        setupViewModel()
        setupGestures()
    }

    // MARK: - UI Actions
    @objc private func didTapSaveButton() {
        viewModel.saveButtonPressed()
    }

    // MARK: - Private methods
    private func setupUI() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.rightBarButtonItem = rightBarButtonItem

        authorLabel.font = Font.text
    }

    private func setupHero() {
        hero.isEnabled = true
        imageView.hero.isEnabled = true
        authorLabel.hero.isEnabled = true
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.actionCallback = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .stateDidUpdate(let state, let prevState):
                self.imageView.hero.id = state.photoViewData.id
                self.authorLabel.hero.id = state.photoViewData.heroLabelID

                self.imageView.kf.indicatorType = IndicatorType.activity
                ImageCache.default.retrieveImage(forKey: state.photoViewData.regularImageCacheKey, options: nil) { (image, _) in
                    self.backgroundImageView.image = image?.kf.blurred(withRadius: 20.0)
                    self.imageView.kf.setImage(with: state.photoViewData.fullPhotoURL, placeholder: image)
                }
                self.authorLabel.text = state.photoViewData.photoCopyright
            case .didFinishDownload(let isSuccess):
                if isSuccess {
                    self.showSuccessMessage()
                }
            }
        }
    }

    private func setupGestures() {

        panGR = UIPanGestureRecognizer(target: self,
                                       action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
    }

    // MARK: - Logic
    private func showSuccessMessage() {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.success)
        view.configureContent(title: "Saved", body: "Photo saved to your Camera Roll")
        SwiftMessages.show(view: view)
    }

    // MARK: - Handlers
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        guard translation.y > 0 else { return }
        let progress = translation.y / 2 / view.bounds.height

        switch panGR.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress)

            // update views' position based on the translation
            let imagePosition = CGPoint(x: imageView.center.x,
                                        y: translation.y + imageView.center.y)
            let authorPosition = CGPoint(x: authorLabel.center.x,
                                       y: translation.y + authorLabel.center.y)
            let closePosition = CGPoint(x: closeButton.center.x,
                                       y: translation.y + closeButton.center.y)
            Hero.shared.apply(modifiers: [
                .position(imagePosition)
                ], to: imageView)
            Hero.shared.apply(modifiers: [
                .position(authorPosition)
                ], to: authorLabel)
            Hero.shared.apply(modifiers: [
                .position(closePosition)
                ], to: closeButton)
        default:
            // finish or cancel the transition based on the progress and user's touch velocity
            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}

// define a small helper function to add two CGPoints
private func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
