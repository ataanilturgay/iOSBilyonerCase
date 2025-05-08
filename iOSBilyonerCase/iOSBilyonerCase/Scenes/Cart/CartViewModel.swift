//
//  CartViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import RxSwift
import RxCocoa

final class CartViewModel: BaseViewModel {
    
    private let behaviorElements = BehaviorRelay<[BaseCellDataProtocol]>(value: [])
    private let navigateToEventsTrigger = PublishSubject<Sport>()
    private var elements = [BaseCellDataProtocol]()
    private let emptyDataTrigger = PublishSubject<Void>()
}

extension CartViewModel: ViewModelType {
    
    struct Input {
        let loadTrigger: Observable<Void>
    }

    struct Output {
        let items: BehaviorRelay<[BaseCellDataProtocol]>
        let emptyDataEvent: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        input.loadTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else {  return }
                self.getCart()
            })
            .disposed(by: disposeBag)
        
        return Output(items: behaviorElements,
                      emptyDataEvent: emptyDataTrigger.asDriverOnErrorJustComplete())
    }
}

// MARK: - Actions

extension CartViewModel {

    func getCart() {
        CartManager.shared.items
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cartItems in
                
                guard let self else { return }
                
                if cartItems.isEmpty {
                    self.emptyDataTrigger.onNext(())
                    return
                }
                self.elements = self.createCellModels(from: cartItems)
                self.behaviorElements.accept(self.elements)
                
            }, onError: { [weak self] error in
                guard let self else { return }
                self.hanleError(error: error)
                print("error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func createCellModels(from data: [Cart]) -> [BaseCellDataProtocol] {
        return data.map { cart in
            return CartTableViewCellViewModel(
                cart: cart
            )
        }
    }
    
    func removeItem(at index: Int) {
        let item = CartManager.shared.items.value[index]
        CartManager.shared.removeItem(item: item)
    }
}
