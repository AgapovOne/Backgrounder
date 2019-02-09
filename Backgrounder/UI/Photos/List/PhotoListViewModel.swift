//
//  PhotoListViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 09/02/2019.
//  Copyright © 2019 Alex Agapov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PhotoListViewModel {

    // MARK: - Declarations
    enum RequestKind {
        case photos
        case collectionPhotos(collection: CollectionViewData)

        var hasPhotoListTypeSelection: Bool {
            switch self {
            case .photos:
                return true
            case .collectionPhotos:
                return false
            }
        }
    }

    // MARK: - Properties
    // MARK: Private
    private let disposeBag = DisposeBag()

    private let photoAPIService: PhotoAPIService
    private let requestKind: RequestKind
    private let showPhoto: ((PhotoViewData) -> Void)?

    private var page = 1
    private var request: Single<[Photo]> {
        switch requestKind {
        case .photos:
            if let query = query.value?.nonEmpty {
                return photoAPIService.searchPhotos(page: page, query: query)
            } else {
                return photoAPIService.getPhotos(page: page)
            }
        case .collectionPhotos(let collection):
            if let query = query.value?.nonEmpty {
                return photoAPIService.searchPhotos(page: page, query: query, collections: [collection.collection.id])
            } else {
                return photoAPIService.getCollectionPhotos(id: collection.collection.id, page: page)
            }
        }
    }

    // MARK: Public
    let photos = BehaviorRelay<[PhotoViewData]>(value: [])

    let isLoading = BehaviorRelay<Bool>(value: false)
    let query = BehaviorRelay<String?>(value: nil)
    let photoListTypeName = BehaviorRelay<String>(value: "")

    var hasPhotoListTypeSelection: Bool {
        return requestKind.hasPhotoListTypeSelection
    }

    var title: String {
        switch requestKind {
        case .photos:
            return "Photos"
        case .collectionPhotos(let collection):
            return collection.title
        }
    }

    var photoListTypes: [String] {
        return PhotoListType.all.map { $0.string }
    }

    init(photoAPIService: PhotoAPIService, requestKind: RequestKind, showPhoto: ((PhotoViewData) -> Void)?) {
        self.photoAPIService = photoAPIService
        self.requestKind = requestKind
        self.showPhoto = showPhoto
        photoListTypeName.accept(photoAPIService.photoListType.string)
        query
            .map { query in
                if case .photos = requestKind {
                    return query?.nonEmpty == nil ? photoAPIService.photoListType.string : ""
                }
                return ""
            }
            .bind(to: photoListTypeName)
            .disposed(by: disposeBag)
    }

    // MARK: - Public
    func reload() {
        page = 1
        load()
    }

    func loadNext() {
        page += 1
        load()
    }

    func selectPhotoType(_ name: String) {
        let newType = PhotoListType(name)
        photoAPIService.photoListType = newType
        photoListTypeName.accept(newType.string)
        reload()
    }

    func select(_ item: PhotoViewData) {
        showPhoto?(item)
    }

    func willDisplayCell(cell: UICollectionViewCell, at indexPath: IndexPath) {
        if indexPath.row == photos.value.count - 1 {
            loadNext()
        }
    }

    func didEndDisplayingCell(cell: UICollectionViewCell, indexPath: IndexPath) {
        (cell as? PhotoCell)?.cancelDownloadIfNeeded()
    }

    // MARK: - Private
    private func load() {
        guard isLoading.value == false else { return }
        isLoading.accept(true)
        request
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] response in
                guard let self = self else { return }
                self.isLoading.accept(false)
                switch response {
                case .success(let items):
                    if self.page == 1 {
                        self.photos.accept(items.map(PhotoViewData.init))
                    } else {
                        self.photos.accept(self.photos.value + items.map(PhotoViewData.init))
                    }
                case .error(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
