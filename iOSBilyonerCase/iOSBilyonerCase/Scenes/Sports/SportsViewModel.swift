//
//  SportsViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import Foundation
import RxSwift
import RxCocoa

final class SportsViewModel: BaseViewModel {
    
    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let navigateToEventsTrigger = PublishSubject<Sport>()
    
    var elements = [BaseCellDataProtocol]()
}

extension SportsViewModel: ViewModelType {
    
    struct Input {

        let loadTrigger: Observable<Void>
        let selection: Driver<SportsTableViewCellViewModel>
    }

    struct Output {

        let items: BehaviorRelay<[BaseCellDataProtocol]>
        let navigateToEvents: Driver<Sport>
    }
    
    func transform(input: Input) -> Output {
        input.loadTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else {  return }
                self.getSports()
            })
            .disposed(by: disposeBag)
        
        input.selection.map { model in model.sport }
            .asObservable()
            .bind(to: navigateToEventsTrigger)
            .disposed(by: disposeBag)
        
        return Output(items: behaviorElements,
                      navigateToEvents: navigateToEventsTrigger.asDriverOnErrorJustComplete())
    }
}

// MARK: - Actions

extension SportsViewModel {

    func getSports() {
        self.provider.getSports()
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
    
    private func createCellModels(from data: [Sport]) -> [BaseCellDataProtocol] {
        return data
            .filter({ $0.active })
            .map { sport in
                return SportsTableViewCellViewModel(
                    sport: sport,
                    title: sport.title
            )
        }
    }
}
