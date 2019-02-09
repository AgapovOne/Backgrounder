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

        var hasDropdownItems: Bool {
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
            return photoAPIService.getPhotos(page: page)
        case .collectionPhotos(let collection):
            return photoAPIService.getCollectionPhotos(id: collection.collection.id, page: page)
        }
    }

    // MARK: Public
    var hasDropdownItems: Bool {
        return requestKind.hasDropdownItems
    }
    private(set) var photos = BehaviorRelay<[PhotoViewData]>(value: [])

    private(set) var isLoading = BehaviorRelay<Bool>(value: false)

    var title: String {
        switch requestKind {
        case .photos:
            return "Photos"
        case .collectionPhotos(let collection):
            return collection.title
        }
    }

    var dropdownItem: String {
        return photoAPIService.photoListType.string
    }

    var dropdownItems: [String] {
        return PhotoListType.all.map({ $0.string })
    }

    init(photoAPIService: PhotoAPIService, requestKind: RequestKind, showPhoto: ((PhotoViewData) -> Void)?) {
        self.photoAPIService = photoAPIService
        self.requestKind = requestKind
        self.showPhoto = showPhoto
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

    func selectNavigationType(at index: Int) {
        photoAPIService.photoListType = PhotoListType.all[index]
        load()
    }

    func selectItem(at indexPath: IndexPath) {
        showPhoto?(photos.value[indexPath.row])
    }

    // MARK: - Private
    private func load() {
        isLoading.accept(true)
        request
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] (response) in
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
