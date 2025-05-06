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

    func isNil() -> Driver<Bool> {
        return flatMap { (element) -> Driver<Bool> in
            if element.value == nil {
                return .just(true)
            } else {
                return .just(false)
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

    func filterNilKeepOptional() -> Observable<Element> {
        return self.filter { (element) -> Bool in
            return element.value != nil
        }
    }

    func replaceNil(with nilValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .just(nilValue)
            }
        }
    }
}

protocol BooleanType {
    
    var boolValue: Bool { get }
}
extension Bool: BooleanType {
    
    var boolValue: Bool { return self }
}

// Maps true to false and vice versa
extension Observable where Element: BooleanType {
    
    func not() -> Observable<Bool> {
        return self.map { input in
            return !input.boolValue
        }
    }
}

extension Observable where Element: Equatable {
    
    func ignore(value: Element) -> Observable<Element> {
        return filter { (selfE) -> Bool in
            return value != selfE
        }
    }
}

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension SharedSequenceConvertibleType where Element == Bool {

    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return map { (input) -> Bool in
            return !input
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

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
