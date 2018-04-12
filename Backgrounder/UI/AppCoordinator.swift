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

final class AppCoordinator: Coordinator<DeepLink> {

    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }

    override func start(with link: DeepLink?) {
        switch link {
        case .photos?:
            runMainFlow()
        case .onboarding?:
            runOnboardingFlow()
        default:
            runMainFlow()
        }
    }

    private func runOnboardingFlow() {

    }

    private func runMainFlow() {
        let coordinator = PhotosCoordinator(router: router)
        addChild(coordinator)
        coordinator.start()
    }
}
