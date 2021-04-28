//
//  ListEventCoordinator.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import UIKit

class ListEventCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init() {}
    
    func start() -> UINavigationController {
        let service = ListEventService()
        let viewModel = ListEventsViewModel(service: service)
        viewModel.coordinatorDelegate = self
        let viewController = ListEventsViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        return navigationController ?? UINavigationController()
    }
    
    func start() {
        let navigationController: UINavigationController = start()
        self.navigationController?.pushViewController(navigationController, animated: false)
    }
}

//MARK: - ListEventCoordinatorDelegate

extension ListEventCoordinator: ListEventCoordinatorDelegate {

    func startDetail(event ev: Event) {
        let service = ListEventService()
        let viewModel = ListDetailEventsViewModel(event: ev, service: service)
        let viewController = ListDetailEventsViewController(viewModel: viewModel)
        viewModel.viewDelegate = viewController
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
}
