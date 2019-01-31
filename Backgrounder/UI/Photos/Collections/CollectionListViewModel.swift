//
//  CollectionListViewModel.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CollectionListViewModel {

    // MARK: - Inputs
    let load: AnyObserver<Void>
    let loadNext: AnyObserver<Void>

    let didSelectItem: AnyObserver<CollectionViewData>

    typealias DisplayCellType = (cell: UICollectionViewCell, at: IndexPath)
    let willDisplayCell: AnyObserver<DisplayCellType>
    let didEndDisplayingCell: AnyObserver<DisplayCellType>

    // MARK: - Outputs
    let title: Observable<String>

    let collections: Driver<[CollectionViewData]>
    let isLoading: Driver<Bool>

    // MARK: Navigation output
    let showCollection: Observable<CollectionViewData>

    // MARK: - Properties
    private let collectionAPIService: CollectionAPIService

//    private var page = 1 // starts at 1

    // MARK: - Lifecycle
    init(title: String, collectionAPIService: CollectionAPIService) {
        self.collectionAPIService = collectionAPIService

        let _load = PublishSubject<Void>()
        load = _load.asObserver()

        let _loadNext = PublishSubject<Void>()
        loadNext = _loadNext.asObserver()

        let _willDisplayCell = PublishSubject<DisplayCellType>()
        willDisplayCell = _willDisplayCell.asObserver()

        let _didEndDisplayingCell = PublishSubject<DisplayCellType>()
        didEndDisplayingCell = _didEndDisplayingCell.asObserver()

        let _didSelectItem = PublishSubject<CollectionViewData>()
        didSelectItem = _didSelectItem.asObserver()

        showCollection = _didSelectItem.asObservable()

        self.title = Single.just(title).asObservable()

        let firstLoad = _load
//            .do(onNext: { [weak self] _ in
//                self?.page = 1
//            })
            .startWith(())

        let nextLoad = _loadNext
//            .do(onNext: { [weak self] _ in
//            self?.page += 1
//        })

        let request = Observable.merge(firstLoad, nextLoad)
            .flatMapLatest { _ -> Observable<[CollectionViewData]> in
//                guard let self = self else { return Observable.error(RxError.unknown) }
                return collectionAPIService
                    .getCollections(page: 1)
                    .map({ $0.map(CollectionViewData.init) })
                    .asObservable()
            }
            .debug()

        collections = request
            .asDriver(onErrorJustReturn: [])

        isLoading = Observable
            .merge(_load.map({ true }), request.catchErrorJustReturn([])
                .map({ _ in false }))
                .asDriver(onErrorJustReturn: false)
    }
}
