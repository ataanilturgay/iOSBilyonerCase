//
//  BaseViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController, Navigatable {
    
    let disposeBag = DisposeBag()
    var navigator: Navigator!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        applyStyling()
        bindViewModel()
    }

    func bindViewModel() {

        // subclasses should override and call super
    }

    func applyStyling() {

        // subclasses should override and call super
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
}

extension BaseViewController {
    
    func showAlert(with viewModel: Alert.ViewModel) {

        Alert.showAlert(with: viewModel)
    }
}

extension Reactive where Base: BaseViewController {
    
    var alert: Binder<Alert.ViewModel> {
        return Binder(self.base) { (baseVC, viewModel) in
            baseVC.showAlert(with: viewModel)
        }
    }
}
