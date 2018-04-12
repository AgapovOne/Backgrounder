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
    struct State {
        enum LoadingState {
            case
            `default`,
            loading,
            error(Error)
        }

        let title: String

        var photos: [Photo]

        var loadingState: LoadingState
    }

    enum Action {
        case stateDidUpdate(newState: State, prevState: State?)
    }

    typealias ActionClosure = (Action) -> Void

    private var state: State {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: oldValue))
        }
    }
    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let photoService: PhotoService

    private var page = 1

    private func load() {
        switch state.loadingState {
        case .loading: break
        default:
            state.loadingState = .loading
            photoService
                .getPhotos(page: page)
                .subscribe(onNext: { items in
                    var photos = [Photo]()
                    if self.page == 1 {
                        photos = items
                    } else {
                        photos = self.state.photos + items
                    }
                    self.state = State(
                        title: self.state.title,
                        photos: photos,
                        loadingState: .default
                    )
                }, onError: { (error) in
                    self.state.loadingState = .error(error)
                })
                .disposed(by: disposeBag)
        }
    }

    private func loadNext() {
        page += 1
        load()
    }

    // MARK: - Lifecycle
    init(title: String, photoService: PhotoService = PhotoService()) {
        self.photoService = photoService
        state = State(
            title: title,
            photos: [],
            loadingState: .default
        )

    }

    var actionCallback: ActionClosure? {
        didSet {
            actionCallback?(.stateDidUpdate(newState: state, prevState: nil))
        }
    }

    // MARK: - Public interface
    // MARK: Navigation output
    var showPhoto: ((Photo) -> Void)?

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
}
