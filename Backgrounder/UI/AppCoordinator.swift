import UIKit

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

class AppCoordinator: Coordinator<DeepLink>, UITabBarControllerDelegate {

    let tabBarController = BaseTabBarController()

    var tabs: [UIViewController: Coordinator<DeepLink>] = [:]

    lazy var photosCoordinator: PhotosCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = TabBarConfiguration.Item.photos
        let router = Router(navigationController: navigationController)
        let coordinator = PhotosCoordinator(router: router, title: "Photos", startPoint: .photos)
        return coordinator
    }()

    lazy var collectionsCoordinator: PhotosCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = TabBarConfiguration.Item.collections
        let router = Router(navigationController: navigationController)
        let coordinator = PhotosCoordinator(router: router, title: "Collections", startPoint: .collections)
        return coordinator
    }()

    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(tabBarController, hideBar: true)
        tabBarController.delegate = self
        setTabs([
            photosCoordinator,
            collectionsCoordinator
            ])
    }

    func setTabs(_ coordinators: [Coordinator<DeepLink>], animated: Bool = false) {
        tabs = [:]

        // Store view controller to coordinator mapping
        let vcs = coordinators.map { coordinator -> UIViewController in
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }

        tabBarController.setViewControllers(vcs, animated: animated)
    }
}
