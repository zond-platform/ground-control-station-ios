//
//  AppDelegate.swift
//  Aeroglaz
//
//  Created by Evgeny Agamirzov on 12/5/18.
//  Copyright © 2018 Evgeny Agamirzov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = Environment.rootViewController
        window!.makeKeyAndVisible()
        Environment.connectionService.start()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Environment.mapViewController.repositionLegalLabels()
    }
}

