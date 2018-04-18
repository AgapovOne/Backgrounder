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
    @IBOutlet private var closeButton: CircleIconButton! {
        didSet {
            closeButton.icon = Font.Icons.close
        }
    }
    @IBOutlet private var saveButton: CircleIconButton! {
        didSet {
            saveButton.icon = Font.Icons.gallery
        }
    }
    @IBOutlet private var shareButton: CircleIconButton! {
        didSet {
            shareButton.icon = Font.Icons.share
        }
    }

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
        setupActions()
    }

    // MARK: - Private methods
    private func setupUI() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        authorLabel.font = Font.text
        imageView.kf.indicatorType = IndicatorType.activity
        backgroundImageView.image = UIImage.from(color: Configuration.Color.tintColor)
    }

    private func setupHero() {
        hero.isEnabled = true
        [imageView, authorLabel, closeButton, saveButton, shareButton].forEach {
            $0.hero.isEnabled = true
        }
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.actionCallback = { [weak self] action in
            guard let `self` = self else { return }
            switch action {
            case .stateDidUpdate(let state, let prevState):
                self.imageView.hero.id = state.photoViewData.heroID
                self.authorLabel.hero.id = state.photoViewData.heroLabelID

                self.downloadFullPhotoIfNeeded(fullPhotoURL: state.photoViewData.fullPhotoURL,
                                               regularPhotoURL: state.photoViewData.regularPhotoURL)

                self.authorLabel.text = state.photoViewData.photoCopyright

                [self.saveButton, self.shareButton].forEach {
                    $0.isEnabled = state.isFullPhotoAvailable
                }
            case .didFinishDownload(let isSuccess):
                if isSuccess {
                    self.showSuccessMessage()
                }
            case .showShare(let image):
                self.showShare(image: image)
            }
        }
    }

    private func setupGestures() {
        panGR = UIPanGestureRecognizer(target: self,
                                       action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
    }

    private func setupActions() {
        shareButton.addTarget(self, action: #selector(tapShareButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
    }

    // MARK: - Logic
    private func showSuccessMessage() {
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.success)
        view.configureContent(title: "Saved", body: "Photo saved to your Camera Roll")
        SwiftMessages.show(view: view)
    }

    private func showShare(image: UIImage) {
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        present(activityViewController, animated: true)
    }

    private func downloadFullPhotoIfNeeded(fullPhotoURL: URL, regularPhotoURL: URL) {
        if
            imageView.kf.webURL?.cacheKey == fullPhotoURL.cacheKey,
            ImageCache.default.imageCachedType(forKey: fullPhotoURL.cacheKey).cached
        {

        } else {
            ImageCache.default.retrieveImage(forKey: regularPhotoURL.cacheKey, options: nil) { [weak self] (image, _) in
                DispatchQueue.main.async {
                    self?.backgroundImageView.image = image?.kf.blurred(withRadius: 20.0)
                }

                self?.imageView.kf.setImage(with: fullPhotoURL, placeholder: image, completionHandler: { (fullImage, _, _, _) in
                    if fullImage != nil {
                        self?.viewModel.fullPhotoDownloaded()
                    }
                })
            }
        }
    }

    // MARK: - Actions
    @objc private func tapShareButton() {
        viewModel.shareButtonPressed()
    }

    @objc private func tapSaveButton() {
        viewModel.saveButtonPressed()
    }

    // MARK: - Handlers
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height

        switch panGR.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress)
            guard translation.y > 0 else { return }

            // update views' position based on the translation
            let imagePosition = CGPoint(x: imageView.center.x,
                                        y: translation.y + imageView.center.y)
            let authorPosition = CGPoint(x: authorLabel.center.x,
                                       y: translation.y + authorLabel.center.y)
            let closePosition = CGPoint(x: closeButton.center.x,
                                       y: translation.y + closeButton.center.y)
            Hero.shared.apply(modifiers: [.position(imagePosition)], to: imageView)
            Hero.shared.apply(modifiers: [.position(authorPosition)], to: authorLabel)
            Hero.shared.apply(modifiers: [.position(closePosition)], to: closeButton)
        default:
            // finish or cancel the transition based on the progress and user's touch velocity
            if
                translation.y > 0,
                progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3
            {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}
