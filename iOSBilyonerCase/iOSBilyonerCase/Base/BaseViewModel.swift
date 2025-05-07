//
//  BaseViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation
import RxSwift
import RxMoya
import RxCocoa

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {

    let provider: BetAPIService

    var disposeBag = DisposeBag()

    internal let error = ErrorTracker()

    let parsedError = PublishSubject<ApiError>()
    let showMessage = PublishSubject<Alert.ViewModel>()
    
    let cartItemCount = BehaviorRelay<Int>(value: 0)

    init(provider: BetAPIService) {
        self.provider = provider
        super.init()

        error
            .mapToApiError()
            .debounce(.milliseconds(Global.Constants.ErrorView.delay), scheduler: MainScheduler.instance)
            .bind(to: parsedError)
            .disposed(by: disposeBag)
    }

    deinit {
        print("\(type(of: self)): Deinited")
    }
    
    func addItemToCart() {
        let newCount = cartItemCount.value + 1
        cartItemCount.accept(newCount)
    }
    
    func removeItemFromCart() {
        let newCount = max(0, cartItemCount.value - 1)
        cartItemCount.accept(newCount)
    }
}
