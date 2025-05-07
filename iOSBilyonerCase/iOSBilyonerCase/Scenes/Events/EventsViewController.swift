//
//  EventsViewController.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//


import UIKit
import RxSwift
import RxCocoa

final class EventsViewController: BaseViewController {

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    // MARK: - Variables
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTextTrigger = PublishSubject<String?>()

    var viewModel: EventsViewModel
    init(viewModel: EventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.resignFirstResponder()
    }

    override func applyStyling() {
        super.applyStyling()
        searchController.searchBar.tintColor = .white
    }

    override func bindViewModel() {
        super.bindViewModel()

        let searchText = Observable.of(searchController.searchBar.rx.text.asObservable(), searchTextTrigger).merge()
        let input = EventsViewModel.Input(
            loadTrigger: Observable.just(()),
            selection: tableView.rx.modelSelected(EventsTableViewCellViewModel.self).asDriver(),
            searchText: searchText
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
        
        output.navigateToDetail.asObservable()
            .map({ [weak self] (event) -> EventDetailViewModel? in

            guard let self else { return nil }

            let eventDetailViewModel = EventDetailViewModel(
                provider: self.viewModel.provider,
                event: event)
            return eventDetailViewModel
        }).filterNil().subscribe(onNext: { [weak self] (viewModel) in

            DispatchQueue.main.async {
                guard let self else { return }
                self.navigator.show(scene: .eventDetail(viewModel: viewModel),
                                    sender: self,
                                    animated: true,
                                    transition: .navigation)
            }
        }).disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked.map({ _ in "" }).bind(to: searchTextTrigger).disposed(by: disposeBag)
    }
}

// MARK: - UIScrollViewDelegate

extension EventsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - Configuration

extension EventsViewController {

    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.registerClassCell(type: EventsTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}
