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

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Public interface
    title = "Latest"

    // MARK: - Inputs
    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: AnyObserver<String>
    
    /// Call to show language list screen.
    let chooseLanguage: AnyObserver<Void>
    
    /// Call to open repository page.
    let selectRepository: AnyObserver<RepositoryViewModel>
    
    /// Call to reload repositories.
    let reload: AnyObserver<Void>
    
    // MARK: - Outputs
    let photos = Observable<[Photo]>
    
    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>
    
    /// Emits a formatted title for a navigation item.
    let title: Observable<String>
    
    /// Emits an error messages to be shown.
    let alertMessage: Observable<String>
    
    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>
    
    /// Emits when we should show language list.
    let showLanguageList: Observable<Void>

    init() {
        
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        self.photos = _reload.map {
            Provider.default.rx
                .request(.photos(page: 1, perPage: 40, orderBy: .latest))
                .map(Array<Photo>.self)
                .subscribe { (event) in
                    switch event {
                    case .error(let err):
                        switch err as? MoyaError {
                        case .underlying(let err, let res)?:
                            print((err, res))
                        default:
                            print("Unknown error\n\n \(err)")
                        }
                        self.photos.value = []
                    case .success(let result):
                        self.photos.value = result
                    }
                }
        }
        
        
        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguage.asObserver()
        
        self.title = _currentLanguage.asObservable()
            .map { "\($0)" }
        
        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()
        
        self.repositories = Observable.combineLatest( _reload, _currentLanguage) { _, language in language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }
        
        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }
        
        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
    
    func refresh() {
        Provider.default.rx
            .request(.photos(page: 1, perPage: 40, orderBy: .latest))
            .map(Array<Photo>.self)
            .subscribe { (event) in
                switch event {
                case .error(let err):
                    switch err as? MoyaError {
                    case .underlying(let err, let res)?:
                        print((err, res))
                    default:
                        print("Unknown error\n\n \(err)")
                    }
                    self.photos.value = []
                case .success(let result):
                    self.photos.value = result
                }
            }.disposed(by: disposeBag)
    }
}
