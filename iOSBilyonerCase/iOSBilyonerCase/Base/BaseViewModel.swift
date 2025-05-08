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

class BaseViewModel {

    let provider: BetAPIService

    var disposeBag = DisposeBag()

    internal let error = ErrorTracker()
    let parsedError = PublishSubject<ApiError>()
    let showMessage = PublishSubject<Alert.ViewModel>()
    
    let cartItemCount = BehaviorRelay<Int>(value: 0)

    init(provider: BetAPIService) {
        self.provider = provider

        error
            .mapToApiError()
            .debounce(.milliseconds(Global.Constants.ErrorView.delay), scheduler: MainScheduler.instance)
            .bind(to: parsedError)
            .disposed(by: disposeBag)
    }

    deinit {
        print("\(type(of: self)): Deinited")
    }
}

extension BaseViewModel {
    
    func hanleError(error: Error) {
        if let apiError = error as? ApiError {
            self.parsedError.onNext(apiError)
        } else {
            self.parsedError.onNext(.unknown)
        }
    }
}
