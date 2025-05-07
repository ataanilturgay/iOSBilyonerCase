//
//  AppDelegate.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.showInitialScreen(in: window)
        
        return true
    }
}
