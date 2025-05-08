//
//  OptionalType.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation
import RxSwift
import RxCocoa

protocol OptionalType {
    
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    
    var value: Wrapped? {
        return self
    }
}

extension Driver where Element: OptionalType {

    func filterNil() -> Driver<Element.Wrapped> {
        return flatMap { (element) -> Driver<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

extension Observable where Element: OptionalType {
    
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

extension ObservableType {

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
}
