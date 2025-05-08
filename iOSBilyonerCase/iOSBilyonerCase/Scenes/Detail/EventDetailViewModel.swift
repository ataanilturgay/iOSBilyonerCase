//
//  EventDetailViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import RxSwift
import RxCocoa

final class EventDetailViewModel: BaseViewModel {
    
    let selectedProviderIndex = BehaviorRelay<Int>(value: 0)
    private var oddsModel: Odds?

    private var event: Event
    init(provider: BetAPIService, event: Event) {
        self.event = event
        super.init(provider: provider)
    }
    
    private var betProviders = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let emptyDataTrigger = PublishSubject<Void>()
}

extension EventDetailViewModel: ViewModelType {
    
    struct Input {
        let loadTrigger: Observable<Void>
        let selectedProviderIndex: Observable<Int>
    }

    struct Output {
        let items: BehaviorRelay<[BaseCellDataProtocol]>
        let providers: BehaviorRelay<[BaseCellDataProtocol]>
        let emptyDataEvent: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.loadTrigger
            .flatMapLatest { [weak self] _ -> Observable<Odds> in
                guard let self else { return Observable.empty() }
                
                return self.provider.getEventOdds(id: self.event.id, sportKey: self.event.sportKey)
                    .asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] oddsModel in
                
                guard let self else { return }
                self.oddsModel = oddsModel
                if oddsModel.bookmakers.count == 0 {
                    
                    self.emptyDataTrigger.onNext(())
                    return
                }
                self.betProviders.accept(self.createBetProvidersCellModels(from: oddsModel))
                self.selectedProviderIndex.accept(0)
            })
            .disposed(by: disposeBag)
        
        input.selectedProviderIndex
            .subscribe(onNext: { [weak self] index in
                guard let self, let oddsModel = self.oddsModel, let bookmaker = self.oddsModel?.bookmakers[safe: index] else { return }
                self.behaviorElements.accept(self.createOddsItems(from: bookmaker, odds: oddsModel))
            })
            .disposed(by: disposeBag)
        
        return Output(
            items: behaviorElements,
            providers: betProviders,
            emptyDataEvent: emptyDataTrigger.asDriverOnErrorJustComplete()
        )
    }
}

// MARK: - Actions

extension EventDetailViewModel {
    
    private func createBetProvidersCellModels(from data: Odds) -> [BaseCellDataProtocol] {
        let model = EventDetailProviderTableViewCellViewModel(
            betProviders: data.bookmakers,
            title: data.sportTitle
        )
        return [model]
    }
    
    private func createOddsItems(from bookmaker: Bookmaker, odds: Odds) -> [BaseCellDataProtocol] {
        return bookmaker.markets.flatMap { market in
            market.outcomes.map { outcome in
                EventDetailOddsTableViewCellViewModel(
                    odds: odds,
                    outcome: outcome,
                    shouldShowTitle: true
                )
            }
        }
    }
}
