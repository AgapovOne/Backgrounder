//
//  PhotosViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class PhotosViewModel {

    // MARK: - Declarations
    enum State {
        case
        `default`,
        loading,
        error(Error),
        empty
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Public interface
    // MARK: Inputs
    let selectPhoto: AnyObserver<Photo>
    
    let reload: AnyObserver<Void>
    
    // MARK: Outputs
    let title: Observable<String>
    
    let photos: Observable<[Photo]>
    
    let state: Observable<State>
    
    let showPhoto: Observable<Photo>

    init(title: String, photoService: PhotoService = PhotoService()) {
        
        self.title = Observable.just(title)
        
        let _state = BehaviorSubject<State>(value: .empty)
        self.state = _state.asObservable()
        
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        self.photos = _reload.flatMap { _ -> Observable<[Photo]> in
            _state.onNext(.loading)
            return photoService
                .getPhotos(page: 1)
                .catchError({ (error) in
                    _state.onNext(.error(error))
                    return Observable.just([])
                })
                .do(onNext: { _ in
                    _state.onNext(.default)
                })
        }

        let _selectPhoto = PublishSubject<Photo>()
        self.selectPhoto = _selectPhoto.asObserver()
        self.showPhoto = _selectPhoto.asObservable()
    }
}
