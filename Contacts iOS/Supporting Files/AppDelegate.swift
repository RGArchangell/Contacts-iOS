//
//  AppDelegate.swift
//  Contacts iOS
//
//  Created by Archangel on 09/08/2019.
//  Copyright © 2019 Archangel. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var mainCoordinator: MainCoordinator = createMainCoordinator()
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startMainCoordinator()
        return true
    }
    
    private func createMainCoordinator() -> MainCoordinator {
        let windowFrame = UIScreen.main.bounds
        
        let newWindow = UIWindow(frame: windowFrame)
        self.window = newWindow
        
        return MainCoordinator(window: newWindow)
    }
    
    private func startMainCoordinator() {
        mainCoordinator.start()
    }

}
