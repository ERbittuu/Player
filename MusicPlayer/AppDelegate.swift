//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by Sanjay Shah on 14/08/18.
//  Copyright © 2018 Solution Analysts. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
        print("handleEventsForBackgroundURLSession: \(identifier)")
        completionHandler()
    }

    // MARK: - Remote control
    override func remoteControlReceived(with event: UIEvent?) {
        AudioPlayerManager.shared.remoteControlReceivedWithEvent(event)
    }
}
