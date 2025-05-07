//
//  OnlineProvider.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Moya
import RxMoya
import RxSwift
import Alamofire
import Foundation

final class OnlineProvider<Target> where Target: Moya.TargetType {

    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>

    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
        session: Alamofire.Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false,
        online: Observable<Bool> = ReachabilityManager.shared.isOnline()
    ) {
        self.online = online
        self.provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
    
    class func newSessionManager() -> Alamofire.Session {
        let sessionConfiguration = URLSessionConfiguration.af.default
        sessionConfiguration.headers = HTTPHeaders.default
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let manager = Alamofire.Session(configuration: sessionConfiguration)
        return manager
    }

    func request(_ target: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .asObservable()
        
        return online
            .filter { $0 == true } // yalnızca online olduğumda ilerle
            .take(1) // sadece ilk true değerini al
            .flatMap { _ in
                actualRequest.do(onNext: { response in
                    debugPrint("Response: \(response.statusCode)")
                }, onError: { error in
                    if let moyaError = error as? MoyaError {
                        if let data = moyaError.response?.data {
                            debugPrint("Error Body: \(String(data: data, encoding: .utf8) ?? "")")
                        }
                    }
                })
            }
    }

    func request<T: Decodable>(_ target: Target, type: T.Type) -> Observable<T> {
        return request(target)
            .map(T.self)
    }
}
