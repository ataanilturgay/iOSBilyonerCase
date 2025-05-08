//
//  Navigator.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

protocol Navigatable {
    
    var navigator: Navigator! { get set }
}

final class Navigator {

    static let `default` = Navigator()

    enum Scene {

        case none
        
        case sports(viewModel: SportsViewModel)
        case events(viewModel: EventsViewModel)
        case eventDetail(viewModel: EventDetailViewModel)
        case cart(viewModel: CartViewModel)
    }

    enum Transition {

        case root(in: UIWindow,
                  animated: Bool,
                  navigation: Bool = false,
                  animationOptions: UIView.AnimationOptions = .transitionFlipFromLeft)
        case navigation
        case rootNavigation
        case modal(isModalInPresentation: Bool = false)
        case sheet
        case modalWithoutNavigation
        case modalWithFullScreen
        case modalWithOverFullScreen(withNavigation: Bool = true)
        case modalWithOverCurrentContext
        case uiActivitySheet
        case sheetWithoutFullScreen
    }

    private func get(scene: Scene) -> UIViewController? {
        switch scene {
        case .none:
            return nil
            
        case .sports(let viewModel):
            let vc = SportsViewController(viewModel: viewModel)
            return vc
            
        case .events(let viewModel):
            let vc = EventsViewController(viewModel: viewModel)
            return vc
            
        case .eventDetail(let viewModel):
            let vc = EventDetailViewController(viewModel: viewModel)                    
            return vc
            
        case .cart(let viewModel):
            let vc = CartViewController(viewModel: viewModel)
            return vc
        }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false, animated: Bool = true) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: animated)
        } else {
            sender?.navigationController?.popViewController(animated: animated)
        }
    }

    func dismiss(sender: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController = sender?.navigationController {
            navigationController.dismiss(animated: animated, completion: completion)
        } else {
            sender?.dismiss(animated: animated, completion: completion)
        }
    }

    func injectTabBarControllers(in target: UITabBarController) {
        if let children = target.viewControllers {
            for vc in children {
                injectNavigator(in: vc)
            }
        }
    }

    typealias Segue = (scene: Scene, sender: UIViewController?, animated: Bool, transition: Transition)

    static let EmptySegue: Segue = (scene: .none, sender: nil, animated: false, transition: .modal())

    func show(segue: Segue) {
        show(scene: segue.scene, sender: segue.sender, animated: segue.animated, transition: segue.transition)
    }

    // MARK: - invoke a single segue
    func show(scene: Scene, sender: UIViewController?, animated: Bool = true, transition: Transition = .navigation) {
        if let target = get(scene: scene) {
            show(target: target, sender: sender, animated: animated, transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, animated: Bool = true, transition: Transition) {
        injectNavigator(in: target)

        switch transition {
        case .root(in: let window, let isAnimated, let navigation, let animationOptions):

            window.rootViewController = navigation ? UINavigationController(rootViewController: target) : target
            window.makeKeyAndVisible()

            UIView.transition(with: window, duration: isAnimated ? 0.2 : 0.0, options: animationOptions, animations: nil, completion: nil)
            return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: animated)
            return
        }

        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                //add controller to navigation stack
                nav.pushViewController(target, animated: animated)
            }
        case .rootNavigation:
            if let nav = sender.navigationController {
                //set root viewController of navigationController
                nav.setViewControllers([target], animated: animated)
            } else {
                fatalError("must have nav controller to use .rootNavigation")
            }
        case .modal(let isModalInPresentation):
            //present modally
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: target)
                if #available(iOS 13.0, *) {
                    nav.isModalInPresentation = isModalInPresentation
                }
                sender.present(nav, animated: animated, completion: nil)
            }
        case .modalWithFullScreen:
            //present modally full screen
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: target)
                nav.modalPresentationStyle = .fullScreen
                sender.present(nav, animated: animated, completion: nil)
            }
        case .sheet:
            //pagesheet
            DispatchQueue.main.async {
                target.modalPresentationStyle = .overFullScreen
                sender.present(target, animated: animated, completion: nil)
            }
        case .modalWithoutNavigation:
            DispatchQueue.main.async {
                target.modalPresentationStyle = .fullScreen
                sender.present(target, animated: animated, completion: nil)
            }
        case .modalWithOverFullScreen(let hasNavigation):
            //present modally over full screen
            DispatchQueue.main.async {
                if hasNavigation {
                    let nav = UINavigationController(rootViewController: target)
                    nav.modalPresentationStyle = .overFullScreen
                    sender.present(nav, animated: animated, completion: nil)
                } else {
                    target.modalPresentationStyle = .overFullScreen
                    sender.present(target, animated: animated, completion: nil)
                }
            }
        case .modalWithOverCurrentContext:
            DispatchQueue.main.async {
                target.modalPresentationStyle = .overCurrentContext
                sender.present(target, animated: animated, completion: nil)
            }
        case .uiActivitySheet:
            //UIActivitySheet - Share
            DispatchQueue.main.async {
                target.modalPresentationStyle = .overFullScreen
                sender.present(target, animated: animated, completion: nil)
            }
        case .sheetWithoutFullScreen:
            //present modally
            DispatchQueue.main.async {
                target.modalPresentationStyle = .pageSheet
                sender.present(target, animated: animated, completion: nil)
            }
        default: break
        }
    }

    func injectNavigator(in target: UIViewController) {
        // view controller
        if var target = target as? Navigatable {
            target.navigator = self
            return
        }

        // navigation controller
        if let target = target as? UINavigationController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
    }
}
