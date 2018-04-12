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
    enum State {
        case
        `default`,
        loading,
        error(Error)
    }

    // MARK: - Public interface
    // MARK: Navigation output
    let showPhoto: Observable<Photo>

    // MARK: Inputs
    let selectPhoto: AnyObserver<Photo>

    let reload: AnyObserver<Void>

    // MARK: Outputs
    let title: Observable<String>

    let photos: Observable<[Photo]>

    let state: Observable<State>

    init(title: String, photoService: PhotoService = PhotoService()) {

        self.title = Observable.just(title)

        let _state = BehaviorSubject<State>(value: .default)
        self.state = _state.asObservable()

        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        self.photos = _reload
            .throttle(1.0, scheduler: Schedulers.background)
            .flatMap { _ -> Observable<[Photo]> in
                _state.onNext(.loading)
                return photoService
                    .getPhotos(page: 1)
                    .do(onNext: { _ in
                        _state.onNext(.default)
                    })
                    .catchError({ (error) in
                        _state.onNext(.error(error))
                        return Observable.just([])
                    })
            }

        let _selectPhoto = PublishSubject<Photo>()
        self.selectPhoto = _selectPhoto.asObserver()
        self.showPhoto = _selectPhoto.asObservable()
    }
}
