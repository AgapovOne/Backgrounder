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

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let photoService: PhotoService

    // MARK: - Public interface
    // MARK: Navigation output
    var showPhoto: ((Photo) -> Void)?

    // MARK: Inputs
    func didSelectItem(at indexPath: IndexPath) {
        showPhoto?(state.photos[indexPath.row])
    }

    func reload() {
        state.loadingState = .loading
        photoService
            .getPhotos(page: 1)
            .subscribe(onNext: { photos in
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

    // MARK: Outputs
    func configure(cell: PhotoCell, at indexPath: IndexPath) {
        cell.photo = state.photos[indexPath.row]
    }

    func numberOfItems() -> Int {
        return state.photos.count
    }
}
