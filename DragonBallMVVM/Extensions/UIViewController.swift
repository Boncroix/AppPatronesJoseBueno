//
//  UIViewController.swift
//  DragonBallMVVM
//
//  Created by Jose Bueno Cruz on 26/1/24.
//

import UIKit

extension UIViewController {
    func setupNavigationBarWithLogout() {
        navigationController?.navigationBar.tintColor = UIColor.black
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
        navigationItem.rightBarButtonItem = logoutButton
    }
    

    @objc func logoutTapped() {
        UserDefaultsHelper.deleteToken()
        let loginViewController = LoginViewController()
        self.navigationController?.setViewControllers(
            [loginViewController], animated: true)
    }
}
