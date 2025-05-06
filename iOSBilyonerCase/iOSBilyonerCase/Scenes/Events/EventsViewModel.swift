//
//  EventsViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation
import RxSwift
import RxCocoa

final class EventsViewModel: BaseViewModel {
    
    private var sport: Sport
    init(provider: BetAPIService, sport: Sport) {
        self.sport = sport
        super.init(provider: provider)
    }

    // MARK: - Variables

    private let clearData = PublishSubject<Bool>()
    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let navigateToDetailTrigger = PublishSubject<Event>()
    
    var elements = [BaseCellDataProtocol]()
}

extension EventsViewModel: ViewModelType {
    
    struct Input {

        let loadTrigger: Observable<Void>
        let selection: Driver<EventsTableViewCellViewModel>
        let searchText: Observable<String?>
    }

    struct Output {

        let items: BehaviorRelay<[BaseCellDataProtocol]>
        let navigateToDetail: Driver<Event>
    }
    
    func transform(input: Input) -> Output {
        
        input.loadTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else {  return }
                self.getEvents(sportKey: sport.key)
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                guard let self else {  return }
                self.filterContent(query: query ?? "")
            })
            .disposed(by: disposeBag)
        
        input.selection.map { model in model.event }
            .asObservable()
            .bind(to: navigateToDetailTrigger)
            .disposed(by: disposeBag)
        
        return Output(items: behaviorElements,
                      navigateToDetail: navigateToDetailTrigger.asDriverOnErrorJustComplete())
    }
}

// MARK: - Actions

extension EventsViewModel {

    func getEvents(sportKey: String) {
        self.provider.getEvents(sportKey: sportKey)
            .trackError(self.error)
            .asDriver(onErrorDriveWith: .never())
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                
                guard let self else { return }

                self.clearData.onNext(false)
                self.elements = self.createCellModels(from: model)
                self.behaviorElements.accept(self.elements)
                
            }).disposed(by: disposeBag)
    }
    
    private func createCellModels(from data: [Event]) -> [BaseCellDataProtocol] {
        return data.map { event in
            return EventsTableViewCellViewModel(
                event: event,
                title: event.sportTitle,
                shouldShowTitle: true
            )
        }
    }
    
    private func filterContent(query: String) {
        if query.isEmpty {
            behaviorElements.accept(elements)
        } else {
            let filtered = elements.filter {
                guard let vm = $0 as? EventsTableViewCellViewModel else { return false }
                return vm.searchText.lowercased().contains(query.lowercased())
            }
            behaviorElements.accept(filtered)
        }
    }
}
