//
//  PhotoViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Kingfisher

class PhotoViewModel {
    // MARK: - Declarations
    struct State {
        let photoViewData: PhotoViewData
        var isFullPhotoAvailable: Bool
    }

    enum Action {
        case stateDidUpdate(newState: State, prevState: State?)
        case didFinishDownload(isSuccess: Bool)
        case showShare(image: UIImage)
    }

    typealias ActionClosure = (Action) -> Void

    // MARK: - Properties
    private var state: State {
        didSet {
            DispatchQueue.main.async {
                self.actionCallback?(.stateDidUpdate(newState: self.state, prevState: oldValue))
            }
        }
    }

    private let photoService: PhotoService

    // MARK: - Lifecycle
    init(photo: PhotoViewData, photoService: PhotoService = PhotoService()) {
        self.photoService = photoService
        self.state = State(
            photoViewData: photo,
            isFullPhotoAvailable: false
        )
        updateFullPhotoStatus()
    }

    // MARK: - Public interface
    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: Inputs
    func shareButtonPressed() {
        ImageCache.default.retrieveImage(forKey: state.photoViewData.fullPhotoURL.cacheKey, options: nil) { [weak self] (image, _) in
            guard let image = image else { return }
            self?.actionCallback?(.showShare(image: image))
        }
    }

    func saveButtonPressed() {
        // Download logic
        ImageCache.default.retrieveImage(forKey: state.photoViewData.fullPhotoURL.cacheKey, options: nil) { [weak self] (image, _) in
            guard let image = image else {
                DispatchQueue.main.async {
                    self?.actionCallback?(.didFinishDownload(isSuccess: false))
                }
                return
            }
            self?.photoService.tryToSave(image: image) { isSuccess in
                DispatchQueue.main.async {
                    self?.actionCallback?(.didFinishDownload(isSuccess: isSuccess))
                }
            }
        }
    }

    func fullPhotoDownloaded() {
        updateFullPhotoStatus()
    }

    // MARK: - Private
    private func updateFullPhotoStatus() {
        state.isFullPhotoAvailable = ImageCache.default.imageCachedType(forKey: state.photoViewData.fullPhotoURL.cacheKey).cached
    }
}
