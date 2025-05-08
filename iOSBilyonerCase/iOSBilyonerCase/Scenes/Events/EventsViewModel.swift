//
//  EventsViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import RxSwift
import RxCocoa

final class EventsViewModel: BaseViewModel {
    
    private var sport: Sport
    init(provider: BetAPIService, sport: Sport) {
        self.sport = sport
        super.init(provider: provider)
    }

    // MARK: - Variables

    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let navigateToDetailTrigger = PublishSubject<Event>()
    private var elements = [BaseCellDataProtocol]()
    private let emptyDataTrigger = PublishSubject<Void>()
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
        let emptyDataEvent: Driver<Void>
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
                if self.elements.isEmpty { return }
                self.filterContent(query: query ?? "")
            })
            .disposed(by: disposeBag)
        
        input.selection.map { model in model.event }
            .asObservable()
            .bind(to: navigateToDetailTrigger)
            .disposed(by: disposeBag)
        
        return Output(items: behaviorElements,
                      navigateToDetail: navigateToDetailTrigger.asDriverOnErrorJustComplete(),
                      emptyDataEvent: emptyDataTrigger.asDriverOnErrorJustComplete()
        )
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
                
                if model.first?.homeTeam == nil {
                    self.emptyDataTrigger.onNext(())
                    return
                }
                self.elements = self.createCellModels(from: model)
                self.behaviorElements.accept(self.elements)
                
            }).disposed(by: disposeBag)
    }
    
    private func createCellModels(from data: [Event]) -> [BaseCellDataProtocol] {
        return data.map { event in
            return EventsTableViewCellViewModel(
                event: event,
                title: event.sportTitle
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

// MARK: - For Test

extension EventsViewModel: MockTestViewModel {
    
    func testableFilterContent(query: String) {
        self.filterContent(query: query)
    }
    
    func testableSetElements(elements: [BaseCellDataProtocol]) {
        self.elements = elements
    }
    
    func testableSetBehaviourElements(elements: [BaseCellDataProtocol]) {
        self.behaviorElements.accept(elements)
    }
    
    func getElements() -> [BaseCellDataProtocol] {
        return self.elements
    }
    
    func getBehaviourElements() -> BehaviorRelay<[BaseCellDataProtocol]> {
        return self.behaviorElements
    }
}
