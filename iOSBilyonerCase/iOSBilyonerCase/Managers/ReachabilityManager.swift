//
//  ReachabilityManager.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Network
import RxSwift

final class ReachabilityManager {
    
    static let shared = ReachabilityManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")
    private let subject = BehaviorSubject<Bool>(value: true)

    private init() {
        monitor.pathUpdateHandler = { path in
            self.subject.onNext(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    func isOnline() -> Observable<Bool> {
        return subject.asObservable()
    }
}
