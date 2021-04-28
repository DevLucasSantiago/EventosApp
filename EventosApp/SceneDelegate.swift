//
//  SceneDelegate.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: ListEventCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            coordinator = ListEventCoordinator()
            window.rootViewController = coordinator?.start()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
