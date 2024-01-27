//
//  SceneDelegate.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 24/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene:  scene)
        let navigationController = UINavigationController()
        
        if UserDefaultsHelper.getToken() != nil {
            let heroesVC = HeroesCollectionViewController()
            navigationController.setViewControllers([heroesVC], animated: true)
        } else {
            let loginVC = LoginViewController()
            navigationController.setViewControllers([loginVC], animated: true)
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}


