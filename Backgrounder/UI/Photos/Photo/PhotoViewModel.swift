//
//  PhotoViewModel.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import Foundation
import RxSwift

class PhotoViewModel {
    let author: String
    let thumbnailURL: URL
    let fullURL: URL

    let download: AnyObserver<Void>

    let showDownloadResult: Observable<Bool>


    init(photo: Photo) {
        self.author = "\(photo.user.username) \(photo.user.name)"
        self.thumbnailURL = photo.urls.thumbnail
        self.fullURL = photo.urls.full

        let _download = PublishSubject<Void>()
        self.download = _download.asObserver()

        self.showDownloadResult = _download.map {
            
            return true
        }
    }
}
