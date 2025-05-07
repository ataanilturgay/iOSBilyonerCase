//
//  CartViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit
import RxSwift

final class CartViewController: BaseViewController {
    
    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var cartTotalView: CartTotalView = {
        let cartTotalView = CartTotalView()
        cartTotalView.translatesAutoresizingMaskIntoConstraints = false
        return cartTotalView
    }()
    
    var viewModel: CartViewModel
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureCartButton(show: false)
        configureNavigationBar()
        
        let cartTotal = CartManager.shared.calculateCartTotal()
        let eventTitle = "Kuponda \(CartManager.shared.cartItemCount.value) adet etkinlik var"
        cartTotalView.configure(with: CartTotalViewModel(carTotal: cartTotal, eventTitle: eventTitle))
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = CartViewModel.Input(
            loadTrigger: Observable.just(())
        )
        
        let output = viewModel.transform(input: input)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items) { tableView, index, model in
                let indexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath) as? BaseTableViewCell else {
                    return UITableViewCell()
                }
                cell.bind(withProtocol: model)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func applyStyling() {
        super.applyStyling()
    }
}

// MARK: - Actions

extension CartViewController {
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Configuration

extension CartViewController {
    
    private func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(cartTotalView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            cartTotalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTotalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTotalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartTotalView.heightAnchor.constraint(equalToConstant: 100)
        ])
        tableView.registerClassCell(type: CartTableViewCell.self)
    }
    
    private func configureNavigationBar() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.title = "Kupon"
    }
}
