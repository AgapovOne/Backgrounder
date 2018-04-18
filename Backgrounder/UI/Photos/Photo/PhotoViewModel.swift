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
        let photoViewData: PhotoViewData
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

    init(photo: PhotoViewData) {
        self.state = State(
            photoViewData: photo
        )
    }

    // MARK: - Public interface
    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: Inputs
    func saveButtonPressed() {
        // Download logic
        actionCallback?(.didFinishDownload(isSuccess: true))
    // MARK: - Private
    }
}
