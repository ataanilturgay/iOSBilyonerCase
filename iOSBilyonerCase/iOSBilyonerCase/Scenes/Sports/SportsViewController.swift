//
//  SportsViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SportsViewController: BaseViewController {
    
    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    var viewModel: SportsViewModel
    init(viewModel: SportsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "Sports"
    }
    
    override func applyStyling() {
        super.applyStyling()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = SportsViewModel.Input(
            loadTrigger: Observable.just(()),
            selection: tableView.rx.modelSelected(SportsTableViewCellViewModel.self).asDriver()
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
        
        output.navigateToEvents.asObservable()
            .map({ [weak self] (sport) -> EventsViewModel? in

            guard let self else { return nil }

            let eventDetailViewModel = EventsViewModel(
                provider: self.viewModel.provider,
                sport: sport)
            return eventDetailViewModel
        }).filterNil().subscribe(onNext: { [weak self] (viewModel) in

            DispatchQueue.main.async {
                guard let self else { return }
                self.navigator.show(scene: .events(viewModel: viewModel),
                                    sender: self,
                                    animated: true,
                                    transition: .navigation)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - Configuration

extension SportsViewController {

    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.registerClassCell(type: SportsTableViewCell.self)
    }
}
