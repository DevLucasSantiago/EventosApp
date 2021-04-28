//
//  Coordinator.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }

    func start()
}
