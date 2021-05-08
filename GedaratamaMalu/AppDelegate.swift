//
//  AppDelegate.swift
//  GedaratamaMalu
//
//  Created by Ashan Don on 12/27/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let authModelView = AuthenticationViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        authModelView.authDelegate = self
        authModelView.getDefaultJwtWebToken()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate : AuthenticationDelegate{
    
    func getJwtToken(token: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(token, forKey: "JWT_TOKEN")
    }
    
    
}


