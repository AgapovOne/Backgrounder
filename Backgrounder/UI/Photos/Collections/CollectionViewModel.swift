//
//  CollectionViewModel.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

class CollectionViewModel {
    // MARK: - Declarations
    struct State {
        let title: String
    }

    enum Action {
        case stateDidUpdate(newState: State, prevState: State?)
    }

    typealias ActionClosure = (Action) -> Void

    // MARK: - Properties
    private var state: State {
        didSet {
            actionCallback?(.stateDidUpdate(newState: self.state, prevState: oldValue))
        }
    }

    private let collectionAPIService: CollectionAPIService

    // MARK: - Lifecycle
    init(title: String, collectionAPIService: CollectionAPIService) {
        self.collectionAPIService = collectionAPIService

        state = State(title: title)
    }

    // MARK: - Public interface
    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: Navigation output
    // MARK: Inputs
    // MARK: Outputs
    // MARK: - Private
}
