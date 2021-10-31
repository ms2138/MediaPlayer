//
//  CustomTabBarController.swift
//  MediaPlayer
//
//  Created by mani on 2021-10-30.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var authenticationController: UINavigationController {
        let authenticationController = AuthenticationViewController(style: .grouped)
        let authenticationTabBarItem = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), selectedImage: nil)
        authenticationController.tabBarItem = authenticationTabBarItem

        return UINavigationController(rootViewController: authenticationController)
    }
    var libraryController: UINavigationController {
        let libraryViewController = LibraryViewController()
        let libraryTabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "list.and.film"), selectedImage: nil)
        libraryViewController.tabBarItem = libraryTabBarItem

        return UINavigationController(rootViewController: libraryViewController)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let controllers = [libraryController, authenticationController]
        viewControllers = controllers

        selectedIndex = 0
    }
}
