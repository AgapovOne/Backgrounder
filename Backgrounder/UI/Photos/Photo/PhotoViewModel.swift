//
//  PhotoViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation

class PhotoViewModel {
    struct State {
        let author: String
        let thumbnailImageKey: String
        let fullURL: URL
    }

    enum Action {
        case stateDidUpdate(newState: State, prevState: State?)
        case didFinishDownload(isSuccess: Bool)
    }

    typealias ActionClosure = (Action) -> Void

    private var state: State {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: oldValue))
        }
    }

    init(photo: Photo) {
        self.state = State(
            author: "\(photo.user.username) \(photo.user.name)",
            thumbnailImageKey: photo.urls.regular.absoluteString,
            fullURL: photo.urls.full
        )
    }

    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // Inputs
    func saveButtonPressed() {
        // Download logic
        actionCallback?(.didFinishDownload(isSuccess: true))
    }
}
