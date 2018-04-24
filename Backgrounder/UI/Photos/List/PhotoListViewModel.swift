//
//  PhotoListViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class PhotoListViewModel {
    // MARK: - Declarations
    struct State {
        enum LoadingState {
            case
            `default`,
            loading,
            error(Error)
        }

        let title: String

        var photos: [PhotoViewData]

        var loadingState: LoadingState
    }

    enum Action {
        case stateDidUpdate(newState: State, prevState: State?)
    }

    typealias ActionClosure = (Action) -> Void

    // MARK: - Properties
    private var state: State {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: oldValue))
        }
    }

    private let disposeBag = DisposeBag()

    private let photoAPIService: PhotoAPIService

    private var page = 1

    // MARK: - Lifecycle
    init(title: String, photoAPIService: PhotoAPIService) {
        self.photoAPIService = photoAPIService
        state = State(
            title: title,
            photos: [],
            loadingState: .default
        )

    }

    // MARK: - Public interface
    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: Navigation output
    var showPhoto: ((PhotoViewData) -> Void)?

    // MARK: Inputs
    func didSelectItem(at indexPath: IndexPath) {
        showPhoto?(state.photos[indexPath.row])
    }

    func reload() {
        page = 1
        load()
    }

    // MARK: Outputs
    func configure(cell: PhotoCell, at indexPath: IndexPath) {
        cell.photo = state.photos[indexPath.row]
    }

    func numberOfItems() -> Int {
        return state.photos.count
    }

    func willDisplayCell(for indexPath: IndexPath) {
        if indexPath.row == state.photos.count - 1 {
            loadNext()
        }
    }

    // MARK: - Private
    private func load() {
        switch state.loadingState {
        case .loading: break
        default:
            state.loadingState = .loading
            photoAPIService
                .getPhotos(page: page)
                .subscribe({ (response) in
                    switch response {
                    case .success(let items):
                        var photos = [PhotoViewData]()
                        if self.page == 1 {
                            photos = items.map(PhotoViewData.init)
                        } else {
                            photos = self.state.photos + items.map(PhotoViewData.init)
                        }
                        self.state = State(
                            title: self.state.title,
                            photos: photos,
                            loadingState: .default
                        )
                    case .error(let error):
                        self.state.loadingState = .error(error)
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
