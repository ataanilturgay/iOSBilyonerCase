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
    
    private lazy var cartButton: CartButton = {
        let button = CartButton(type: .custom)
        button.setImage(UIImage(systemName: "cart"), for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let disposeBag = DisposeBag()
    var navigator: Navigator!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        applyStyling()
        bindViewModel()
        configureCartButton()
        bindCartBadge()
    }
    
    func configureCartButton(show: Bool = true) {
        if show {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func bindCartBadge() {
        CartManager.shared.cartItemCount
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                guard let self else { return }
                self.cartButton.setBadge(count: count)
            })
            .disposed(by: disposeBag)
    }

    func bindViewModel() {

        // subclasses should override and call super
    }

    func applyStyling() {
        
        // subclasses should override and call super
        view.backgroundColor = .primaryBackgroundColor
    }
    
    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    @objc private func cartButtonTapped() {
        guard let provider = Application.shared.provider else { return }
        let viewModel = CartViewModel(provider: provider)
        navigator.show(scene: .cart(viewModel: viewModel),
                       sender: self,
                       animated: true,
                       transition: .modalWithOverFullScreen(withNavigation: true))
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
