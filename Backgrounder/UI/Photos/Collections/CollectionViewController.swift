//
//  CollectionViewController.swift
//  Backgrounder
//
//  Created by Aleksey Agapov on 27/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import UIKit
import Reusable

class CollectionViewController: UIViewController, StoryboardSceneBased {
    // MARK: - Protocols
    static let sceneStoryboard = Storyboard.main

    // MARK: - UI
    @IBOutlet private var collectionView: PhotoCollectionView!

    // MARK: - Properties
    private var viewModel: CollectionViewModel!

    // MARK: - Lifecycle
    static func instantiate(viewModel: CollectionViewModel) -> CollectionViewController {
        let vc = CollectionViewController.instantiate()
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }

    // MARK: - Private methods
    private func setupUI() {
    }

    private func setupViewModel() {
        assert(viewModel != nil, "View Model should be instantiated. Use instantiate(viewModel:)")

        viewModel.actionCallback = { [weak self] action in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                switch action {
                case .stateDidUpdate(let state, let prevState):
                    self.navigationItem.title = state.title
                }
            }
        }
    }
}
