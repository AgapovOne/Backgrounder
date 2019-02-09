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

final class CollectionListViewModel {

    // MARK: - Outputs
    let title: Observable<String>

    let collections: Observable<[CollectionViewData]>
    let isLoading: Observable<Bool>

    // MARK: Navigation output
    let showCollection: Observable<CollectionViewData>

    // MARK: Inputs & Ouputs
    let query = BehaviorRelay<String?>(value: nil)

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let collectionAPIService: CollectionAPIService

    private var page = 1 // starts at 1
    private let collectionsRelay = BehaviorRelay<[CollectionViewData]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let showCollectionRelay = PublishRelay<CollectionViewData>()

    private var request: Single<[UnsplashCollection]> {
        if let query = query.value?.nonEmpty {
            return collectionAPIService.searchCollections(page: page, query: query)
        } else {
            return collectionAPIService.getCollections(page: page)
        }
    }

    // MARK: - Lifecycle
    init(title: String, collectionAPIService: CollectionAPIService) {
        self.collectionAPIService = collectionAPIService

        self.title = Single.just(title).asObservable()

        collections = collectionsRelay.asObservable()
        isLoading = isLoadingRelay.asObservable()
        showCollection = showCollectionRelay.asObservable()
    }

    // MARK: - Public
    func reload() {
        page = 1
        load()
    }

    func select(_ item: CollectionViewData) {
        showCollectionRelay.accept(item)
    }

    func willDisplayCell(cell: UICollectionViewCell, at indexPath: IndexPath) {
        if indexPath.row == collectionsRelay.value.count - 1 {
            loadNext()
        }
    }

    func didEndDisplayingCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        (cell as? PhotoCollectionCell)?.cancelDownloadIfNeeded()
    }

    // MARK: - Private
    private func loadNext() {
        page += 1
        load()
    }

    private func load() {
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        request
            .observeOn(MainScheduler.instance)
            .map({ $0.map(CollectionViewData.init) })
            .subscribe({ [weak self] (response) in
                guard let self = self else { return }
                self.isLoadingRelay.accept(false)
                switch response {
                case .success(let items):
                    if self.page == 1 {
                        self.collectionsRelay.accept(items)
                    } else {
                        self.collectionsRelay.accept(self.collectionsRelay.value + items)
                    }
                case .error(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
