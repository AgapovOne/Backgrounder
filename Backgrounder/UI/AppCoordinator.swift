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

    lazy var popularCoordinator: PhotosCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = TabBarConfiguration.Item.popular
        let router = Router(navigationController: navigationController)
        let coordinator = PhotosCoordinator(router: router, title: "Popular", type: .curated)
        return coordinator
    }()

    lazy var allCoordinator: PhotosCoordinator = {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = TabBarConfiguration.Item.all
        let router = Router(navigationController: navigationController)
        let coordinator = PhotosCoordinator(router: router, title: "All", type: .all)
        return coordinator
    }()

    override init(router: RouterType) {
        super.init(router: router)
        router.setRootModule(tabBarController, hideBar: true)
        tabBarController.delegate = self
        setTabs([popularCoordinator, allCoordinator])
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


    // Present a vertical flow
//    func presentAuthFlow() {
//        let navigationController = UINavigationController()
//        let navRouter = Router(navigationController: navigationController)
//        let coordinator = AuthCoordinator(router: navRouter)
//
//        coordinator.onCancel = { [weak self, weak coordinator] in
//            self?.router.dismissModule(animated: true, completion: nil)
//            self?.removeChild(coordinator)
//        }
//
//        coordinator.onAuthenticated = { [weak self, weak coordinator] token in
//            self?.store.token = token
//            self?.router.dismissModule(animated: true, completion: nil)
//            self?.removeChild(coordinator)
//        }
//
//        addChild(coordinator)
//        coordinator.start()
//        router.present(coordinator, animated: true)
//    }


    // MARK: UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        guard let coordinator = tabs[viewController] else { return true }

//        // Let's protect this tab because we can
//        if coordinator is AccountCoordinator && !store.isLoggedIn {
//            presentAuthFlow()
//            return false
//        } else {
//            return true
//        }
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
