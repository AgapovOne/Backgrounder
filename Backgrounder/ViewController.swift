//
//  ViewController.swift
//  Backgrounder
//
//  Created by Alex Agapov on 05/12/2017.
//  Copyright © 2017 Alex Agapov. All rights reserved.
//

import UIKit
import RxSwift
import Moya

class ViewController: UIViewController {

    @IBOutlet private var refreshButton: UIButton!
    @IBOutlet private var resultLabel: UILabel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    }
    
    @objc private func refresh() {
        Provider.default.rx.request(.photos(page: 1)).map(Array<Photo>.self)
            .subscribe { (event) in
            switch event {
            case .error(let err):
                switch err as? MoyaError {
                case .underlying(let err, let res)?:
                    self.updateOutput("\(err), \(res)")
                default:
                    self.updateOutput("Unknown error\n\n \(err)")
                }
            case .success(let result):
                self.updateOutput("\(result)")
            }
        }.disposed(by: disposeBag)
    }
    
    
    private func updateOutput(_ text: String) {
        resultLabel.text = text
    }
}
