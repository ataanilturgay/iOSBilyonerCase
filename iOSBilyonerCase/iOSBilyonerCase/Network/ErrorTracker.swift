//
//  ErrorTracker.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation
import RxSwift
import RxMoya
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asDriver(onErrorDriveWith: .empty())
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
    
    func mapToApiError() -> Observable<ApiError> {
        return _subject.map { error in
            guard let moyaError = error as? MoyaError else {
                return .unknown
            }

            if moyaError.errorCode == NSURLErrorNotConnectedToInternet {
                return .network
            }

            if let response = moyaError.response {
                do {
                    let apiError = try response.map(ApiError.self)
                    return apiError
                } catch let decodingError as DecodingError {
                    switch decodingError {
                    case .typeMismatch:
                        return .typeMismatch
                    case .dataCorrupted, .keyNotFound, .valueNotFound:
                        return .parse
                    @unknown default:
                        return .parse
                    }
                } catch {
                    return .parse
                }
            }

            return .unknown
        }
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
