//
//  MockBetAPIService.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import RxSwift

struct MockBetAPIService: BetAPIService {
    
    let errorStatus: Bool
    
    func getSports() -> Single<[Sport]> {
        let mockSports = [
            Sport(key: "Football", group: "", title: "", description: "", active: true, hasOutrights: true),
            Sport(key: "Basketball", group: "", title: "", description: "", active: true, hasOutrights: true)
        ]
        if errorStatus {
            return Single.just([])
        }
        return Single.just(mockSports)
    }
    
    func getEvents(sportKey: String) -> Single<[Event]> {
        let mockEvents = [
            Event(id: "101", sportKey: sportKey, sportTitle: "Football", commenceTime: "", homeTeam: "Besiktas", awayTeam: "Fenerbahce"),
            Event(id: "102", sportKey: sportKey, sportTitle: "Football", commenceTime: "", homeTeam: "Trabzonspor", awayTeam: "Galatasaray"),
        ]
        if errorStatus {
            return Single.just([])
        }
        return Single.just(mockEvents)
    }
    
    func getEventOdds(id: String, sportKey: String) -> Single<Odds> {
        let emptyOdds = Odds(id: "", sportKey: "", sportTitle: "", commenceTime: "", homeTeam: "", awayTeam: "", bookmakers: [])
        
        let mockOdds = Odds(id: id, sportKey: sportKey, sportTitle: "", commenceTime: "", homeTeam: "", awayTeam: "", bookmakers: [
            Bookmaker(key: "1", title: "aaamaker", markets: [
                Market(key: "1", lastUpdate: "", outcomes: [
                    Outcome(name: "Besiktas", price: 2.0, point: 2.5),
                    Outcome(name: "Besiktas", price: 1.0, point: 0.5)
                ], link: nil, sid: nil),
                Market(key: "2", lastUpdate: "", outcomes: [
                    Outcome(name: "Besiktas", price: 2.1, point: 2.5),
                    Outcome(name: "Besiktas", price: 1.3, point: 1.5)
                ], link: nil, sid: nil)
            ], link: nil, sid: nil)
        ])
        if errorStatus {
            return Single.just(emptyOdds)
        }
        return Single.just(mockOdds)
    }
}
