//
//  API.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Moya
import RxSwift
import Alamofire
import Foundation

typealias Payload = PayloadProtocol
typealias MoyaError = Moya.MoyaError

protocol BetAPIService {
    
    func getSports() -> Single<[Sport]>
    func getEvents(sportKey: String) -> Single<[Event]>
    func getEventOdds(id: String, sportKey: String) -> Single<Odds>
}

class API {

    let provider: Networking

    init(provider: Networking) {
        self.provider = provider
    }
    
    class func newSessionManager() -> Alamofire.Session {

        let sessionConfiguration = URLSessionConfiguration.af.default

        sessionConfiguration.headers = HTTPHeaders.default
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let manager = Alamofire.Session(configuration: sessionConfiguration)

        return manager
    }
}

extension API: BetAPIService {
    
    func getSports() -> Single<[Sport]> {
        return requestArray(.sports, type: Sport.self)
    }
    
    func getEvents(sportKey: String) -> Single<[Event]> {
        return requestArray(.events(sportKey: sportKey), type: Event.self)
    }
    
    func getEventOdds(id: String, sportKey: String) -> Single<Odds>  {
        return requestObject(.eventOdds(eventId: id, sportKey: sportKey), type: Odds.self)
    }
}

extension API {

    private func requestObject<T: Decodable>(_ target: BetAPI, type: T.Type) -> Single<T> {
        return provider.request(target)
            .map(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    private func requestArray<T: Decodable>(_ target: BetAPI, type: T.Type) -> Single<[T]> {
        return provider.request(target)
            .map([T].self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}
