//
//  Schedulers.swift
//  Backgrounder
//
//  Created by Alex Agapov on 12/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import RxSwift

enum Schedulers {
    static let background = SerialDispatchQueueScheduler(qos: .background)
}
