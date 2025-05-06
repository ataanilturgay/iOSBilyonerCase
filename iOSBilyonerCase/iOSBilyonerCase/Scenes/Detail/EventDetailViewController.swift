//
//  EventDetailViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift

final class EventDetailViewController: BaseViewController {
    
    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    var viewModel: EventDetailViewModel
    
    init(viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    override func applyStyling() {
        super.applyStyling()
        
        view.backgroundColor = .red
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = EventDetailViewModel.Input(
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
        
        viewModel.parsedError.subscribe(onNext: { [weak self] (error) in

            guard let self else { return }
            self.showAlert(with: Alert.ViewModel(title: error.message))
        }).disposed(by: disposeBag)
    }
}

// MARK: - Configuration

extension EventDetailViewController {

    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.registerClassCell(type: EventDetailTableViewCell.self)
    }
}
