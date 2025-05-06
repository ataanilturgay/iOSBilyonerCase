//
//  Alert.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift

typealias Alert = AlertView

class AlertView {

    class func showAlert(with viewModel: ViewModel) {

        let alertController = UIAlertController(title: viewModel.title,
                                                message: viewModel.message,
                                                preferredStyle: viewModel.preferredStyle)

        viewModel.actions?.forEach({ (action) in

            alertController.addAction(action.bindedUIAlertAction())
        })

        guard let topViewController = Application.topViewController() else {
            return
        }

        // If any alert view is presented at this time
        if topViewController.isKind(of: UIAlertController.self) {

            if topViewController.isBeingDismissed {

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

                    guard let topViewController = Application.topViewController() else {
                        return
                    }

                    topViewController.present(alertController, animated: true, completion: nil)
                }
            } else {
                topViewController.dismiss(animated: true, completion: {

                    guard let topViewController = Application.topViewController() else {
                        return
                    }

                    topViewController.present(alertController, animated: true, completion: nil)
                })
            }
        } else {

            topViewController.present(alertController, animated: true, completion: nil)
        }
    }

    struct ViewModel {

        let title: String?
        let message: String?
        let preferredStyle: UIAlertController.Style
        let actions: [Action]?

        init(title: String? = nil,
             message: String? = nil,
             preferredStyle: UIAlertController.Style = .alert,
             actions: [Action]? = [Action.defaultAction()]) {

            self.title = title
            self.message = message
            self.preferredStyle = preferredStyle
            self.actions = actions
        }

    }

    struct Action {

        let title: String
        let style: UIAlertAction.Style
        let subject: PublishSubject<Void>?

        init(title: String,
             style: UIAlertAction.Style = .default,
             subject: PublishSubject<Void>? = nil) {

            self.title = title
            self.style = style
            self.subject = subject
        }

        static func defaultAction() -> Action {
            return Action(title: "Ok")
        }

        func bindedUIAlertAction() -> UIAlertAction {

            if let subject = subject {
                return UIAlertAction(title: title, style: style) { (_) in
                    subject.onNext(())
                }
            } else {
                return UIAlertAction(title: title, style: style, handler: nil)
            }
        }
    }
}
