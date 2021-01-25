//
//  AppDelegate.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 22/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = self.window ?? UIWindow()
        let categoriesVC = CategoriesViewController.instantiate(from: .Categories)
        self.window!.rootViewController = UINavigationController(rootViewController: categoriesVC)
        self.window!.makeKeyAndVisible()
        return true
    }

}
