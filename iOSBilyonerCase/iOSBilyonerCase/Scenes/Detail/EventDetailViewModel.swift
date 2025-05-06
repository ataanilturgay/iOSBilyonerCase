//
//  EventDetailViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import Foundation
import RxSwift
import RxCocoa

final class EventDetailViewModel: BaseViewModel {
    
    private var event: Event
    init(provider: BetAPIService, event: Event) {
        self.event = event
        super.init(provider: provider)
    }
    
    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    var elements = [BaseCellDataProtocol]()
}

extension EventDetailViewModel: ViewModelType {
    
    struct Input {

        let loadTrigger: Observable<Void>
    }

    struct Output {

        let items: BehaviorRelay<[BaseCellDataProtocol]>
    }
    
    func transform(input: Input) -> Output {
        
        input.loadTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else {  return }
                self.getEventOdds(eventId: event.id, sportKey: event.sportKey)
            })
            .disposed(by: disposeBag)
        
        
        return Output(items: behaviorElements)
    }
}

// MARK: - Actions

extension EventDetailViewModel {

    func getEventOdds(eventId: String, sportKey: String) {
        self.provider.getEventOdds(id: eventId, sportKey: sportKey)
            .trackError(self.error)
            .asDriver(onErrorDriveWith: .never())
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                
                guard let self else { return }

                self.elements = self.createCellModels(from: model)
                self.behaviorElements.accept(self.elements)
                
            }, onError: { error in
                print("error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func createCellModels(from data: Odd) -> [BaseCellDataProtocol] {
        let model = EventDetailTableViewCellViewModel(
            odd: data,
            title: data.sportTitle,
            shouldShowTitle: true
        )
        return [model]
    }
}
