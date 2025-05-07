//
//  EventDetailViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class EventDetailViewController: BaseViewController {
    
    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let selectedProviderIndexRelay = BehaviorRelay<Int>(value: 0)

    private var models: [BaseCellDataProtocol] = []
    
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
        navigationItem.title = "Event Detail"

        AnalyticsManager.shared.sendEvent(event: .eventDetail)
    }
    
    override func applyStyling() {
        super.applyStyling()
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = EventDetailViewModel.Input(
            loadTrigger: Observable.just(()),
            selectedProviderIndex: selectedProviderIndexRelay.asObservable()
        )

        let output = viewModel.transform(input: input)
        
        let combinedItems = Observable.combineLatest(output.providers, output.items)
            .map { providers, odds in
                return providers + odds
            }
            .asDriver(onErrorJustReturn: [])
        
        combinedItems
            .drive(onNext: { [weak self] models in
                guard let self else { return }
                self.models = models
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.parsedError.subscribe(onNext: { [weak self] (error) in

            guard let self else { return }
            self.showAlert(with: Alert.ViewModel(title: error.message))
        }).disposed(by: disposeBag)
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier) as? BaseTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(withProtocol: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let providerCell = cell as? EventDetailProviderTableViewCell {
            providerCell.delegate = self
        } else if let oddsCell = cell as? EventDetailOddsTableViewCell {
            oddsCell.delegate = self
        }
    }
}

// MARK: - EventDetailProviderDelegate

extension EventDetailViewController: EventDetailProviderDelegate {
    
    func didSelectBetProvider(index: Int) {
        selectedProviderIndexRelay.accept(index)
    }
}

// MARK: - EventDetailOddsTableViewCellDelegate

extension EventDetailViewController: EventDetailOddsTableViewCellDelegate {
    
    func didSelectOdds(cartItem: Cart) {
        CartManager.shared.addItem(item: cartItem)
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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = self
        tableView.registerClassCell(type: EventDetailProviderTableViewCell.self)
        tableView.registerClassCell(type: EventDetailOddsTableViewCell.self)
    }
}
