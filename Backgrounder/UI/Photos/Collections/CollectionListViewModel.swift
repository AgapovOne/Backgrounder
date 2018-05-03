//
//  CollectionListViewModel.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation
import RxSwift

class CollectionListViewModel {
    // MARK: - Declarations
    struct State {
        enum LoadingState {
            case
            `default`,
            loading,
            error(Error)
        }

        let title: String

        let collections: [CollectionViewData]
        let loadingState: LoadingState
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

    private let disposeBag = DisposeBag()

    private let collectionAPIService: CollectionAPIService

    private var page = 1

    // MARK: - Lifecycle
    init(title: String, collectionAPIService: CollectionAPIService) {
        self.collectionAPIService = collectionAPIService

        state = State(title: title,
                      collections: [],
                      loadingState: .default)
    }

    // MARK: - Public interface
    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: Navigation output
    var showCollection: ((CollectionViewData) -> Void)?

    // MARK: Inputs
    func didSelectItem(at indexPath: IndexPath) {
        showCollection?(state.collections[indexPath.row])
    }

    func reload() {
        page = 1
        load()
    }

    // MARK: Outputs
    func configure(cell: PhotoCollectionCell, at indexPath: IndexPath) {
        cell.data = state.collections[indexPath.row]
    }

    func willDisplayCell(for indexPath: IndexPath) {
        if indexPath.row == state.collections.count - 1 {
            loadNext()
        }
    }

    // MARK: - Private
    // MARK: - Private
    private func load() {
        switch state.loadingState {
        case .loading: break
        default:
            state = State(
                title: state.title,
                collections: state.collections,
                loadingState: .loading
            )
            collectionAPIService
                .getCollections(page: page)
                .subscribe({ (response) in
                    switch response {
                    case .success(let items):
                        var collections = [CollectionViewData]()
                        if self.page == 1 {
                            collections = items.map(CollectionViewData.init)
                        } else {
                            collections = self.state.collections + items.map(CollectionViewData.init)
                        }
                        self.state = State(
                            title: self.state.title,
                            collections: collections,
                            loadingState: .default
                        )
                    case .error(let error):
                        self.state = State(
                            title: self.state.title,
                            collections: self.state.collections,
                            loadingState: .error(error)
                        )
                    }
                })
                .disposed(by: disposeBag)
        }
    }

    private func loadNext() {
        page += 1
        load()
    }
}
