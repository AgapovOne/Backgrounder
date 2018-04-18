//
//  PhotoService.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 18/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation
import Photos

class PhotoService {
    func tryToSave(image: UIImage, completion: ((Bool) -> Void)? = nil) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        completion?(true)
                    } else {
                        completion?(false)
                    }
                })
            default:
                completion?(false)
            }
        }
    }
}
