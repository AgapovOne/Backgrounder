//
//  CoordinatorFactory.swift
//  Backgrounder
//
//  Created by Alex Agapov on 10/04/2018.
//  Copyright © 2018 Alex Agapov. All rights reserved.
//

import Foundation

protocol CoordinatorFactory {

    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
//    func makeAuthCoordinatorBox(router: Router) -> Coordinator & AuthCoordinatorOutput
//
//    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorOutput
//
//    func makeItemCoordinator(navController: UINavigationController?) -> Coordinator
//    func makeItemCoordinator() -> Coordinator
//
//    func makeSettingsCoordinator() -> Coordinator
//    func makeSettingsCoordinator(navController: UINavigationController?) -> Coordinator
//
//    func makeItemCreationCoordinatorBox() ->
//        (configurator: Coordinator & ItemCreateCoordinatorOutput,
//        toPresent: Presentable?)
//
//    func makeItemCreationCoordinatorBox(navController: UINavigationController?) ->
//        (configurator: Coordinator & ItemCreateCoordinatorOutput,
//        toPresent: Presentable?)
}
