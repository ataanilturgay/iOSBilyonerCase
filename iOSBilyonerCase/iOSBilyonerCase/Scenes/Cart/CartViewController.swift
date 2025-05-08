//
//  CartViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CartViewController: BaseViewController {
    
    // MARK: Constants
    
    private enum Constants {
        
        enum Constraints {
            
            static let bottomAnchor: CGFloat =  100.0
            
            enum CartTotalView {
                
                static let height: CGFloat = 100.0
            }
        }
        
        enum Texts {
            
            static let eventTitle = "Kuponda %d adet etkinlik var"
            
            enum NavBar {
    
                static let title: String = "Kupon"
            }
        }
    }
    
    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
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
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        let input = CartViewModel.Input(
            loadTrigger: Observable.just(())
        )
        
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(CartManager.shared.cartItemCount.asObservable(),
                                 CartManager.shared.items.asObservable())
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] count, items in
            guard let self else { return }
            let cartTotal = CartManager.shared.calculateCartTotal()
            let eventTitle = String(format: Constants.Texts.eventTitle, count)
            self.cartTotalView.configure(with: CartTotalViewModel(carTotal: cartTotal, eventTitle: eventTitle))
        })
        .disposed(by: disposeBag)

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
        
        output.emptyDataEvent.debounce(.milliseconds(Global.Constants.ErrorView.delay)).drive(onNext: { [weak self] _ in

            guard let self else { return }
            self.tableView.removeFromSuperview()
            self.cartTotalView.removeFromSuperview()
            let emptyView = EmptyView(frame: CGRect(x: self.view.bounds.size.width/2 - 100,
                                                    y: self.view.bounds.size.height/2 - 50,
                                                    width: 200,
                                                    height: 100))
            emptyView.configure(with: .cart)
            self.view.addSubview(emptyView)
        }).disposed(by: disposeBag)
        
        viewModel.parsedError.bind(to: rx.errorAlert).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: {  [weak self] indexPath in
                guard let self else { return }
                self.viewModel.removeItem(at: indexPath.row)
            }).disposed(by: disposeBag)
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -Constants.Constraints.bottomAnchor),
            
            cartTotalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTotalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTotalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartTotalView.heightAnchor.constraint(equalToConstant: Constants.Constraints.CartTotalView.height)
        ])
        tableView.registerClassCell(type: CartTableViewCell.self)
    }
    
    private func configureNavigationBar() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: Global.Constants.Images.close),
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.title = Constants.Texts.NavBar.title
    }
}
