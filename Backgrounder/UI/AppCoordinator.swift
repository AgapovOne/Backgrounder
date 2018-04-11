import Foundation

private enum LaunchInstructor {
    case main, onboarding

    static func configure(
        onboardingWasShown: Bool = Defaults.onboardingWasShown
        ) -> LaunchInstructor {

//        switch (onboardingWasShown) {
//        case true: return .main
//        case false: return .onboarding
//        }
        return .main
    }
}

final class AppCoordinator: BaseCoordinator {

    private let router: Router

    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }


    init(router: Router) {
        self.router = router
    }

    override func start() {
        switch instructor {
        case .main: runMainFlow()
        case .onboarding: runOnboardingFlow()
        }
    }

    private func runOnboardingFlow() {
        //    let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        //    coordinator.finishFlow = { [weak self, weak coordinator] in
        //      onboardingWasShown = true
        //      self?.start()
        //      self?.removeDependency(coordinator)
        //    }
        //    addDependency(coordinator)
        //    coordinator.start()
    }

    private func runMainFlow() {
        //    PhotosCoordinator
        let coordinator = PhotosCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }
}
