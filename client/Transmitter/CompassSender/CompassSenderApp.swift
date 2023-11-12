//
//  CompassSenderApp.swift
//  CompassSender
//
//  Created by Ian Christie on 9/22/23.
//

import SwiftUI

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(">> your code here !!")
        if (launchOptions != nil && launchOptions!.keys.contains(UIApplication.LaunchOptionsKey.location)) {
            Global.shared.launchedFromLocation = true
        }
        return true
    }
}

@main
struct CompassSenderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
