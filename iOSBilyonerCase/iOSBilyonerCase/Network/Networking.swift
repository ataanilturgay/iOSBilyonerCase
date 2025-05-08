//
//  Networking.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Moya
import RxSwift
import Alamofire

protocol NetworkingType {

    associatedtype T: TargetType
    var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {

    typealias T = BetAPI
    let provider: OnlineProvider<BetAPI>
}

extension Networking {

    func request(_ token: BetAPI) -> Observable<Moya.Response> {
        let actualRequest = self.provider
            .request(token)

        return actualRequest
    }
}

extension NetworkingType {

    static func getNetworking(session: Alamofire.Session) -> Networking {
        return Networking(provider: newProvider(session, plugins))
    }
}

extension NetworkingType {

    static var plugins: [PluginType] {

        var plugins: [PluginType] = []

        if isNetworkLoggingEnabled {

            plugins.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)))
        }

        return plugins
    }
}

private func newProvider<T>(_ session: Alamofire.Session, _ plugins: [PluginType]) -> OnlineProvider<T> where T: TargetType {

    return OnlineProvider<T>(session: session, plugins: plugins)
}
