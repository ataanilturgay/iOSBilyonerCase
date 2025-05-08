//
//  Application.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift
import FirebaseCore
import FirebaseAnalytics

final class Application {
    
    static let shared = Application()
    
    var window: UIWindow?
    var disposeBag = DisposeBag()
    var provider: BetAPIService?
    var navigator: Navigator
    
    private init() {
        navigator = Navigator.default
        updateProvider()
        configureNavigationBar()
        configureFirebase()
    }

    // MARK: - Private Methods

    private func updateProvider() {
        let sessionManager = API.newSessionManager()
        let provider = Networking.getNetworking(session: sessionManager)
        let api = API(provider: provider)
        self.provider = api
    }
    
    // MARK: - Public Methods

    func showInitialScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else { return }
        self.window = window

        let viewModel = SportsViewModel(provider: provider)
        self.navigator.show(scene: .sports(viewModel: viewModel),
                            sender: nil,
                            transition: .root(in: window, animated: true, navigation: true))
    }
    
    // MARK: - Configure Firebase
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }
    
    // MARK: - Configure Nav Bar

    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.currentKeyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            if let _ = presented as? UISearchController {
                return base
            } else {
                return topViewController(presented)
            }
        }
        
        if let searchController = base as? UISearchController,
           let next = searchController.next as? UIViewController {
            return topViewController(next)
        }
        return base
    }
}

var isNetworkLoggingEnabled: Bool {
    return true
}
