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
}

extension CartViewModel: ViewModelType {
    
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
                self.getCart()
            })
            .disposed(by: disposeBag)
        
        return Output(items: behaviorElements)
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

                self.elements = self.createCellModels(from: cartItems)
                self.behaviorElements.accept(self.elements)
                
            }, onError: { error in
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
