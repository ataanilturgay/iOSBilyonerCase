//
//  Odds.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

struct Odds: Decodable {
    
    let id, sportKey, sportTitle: String
    let commenceTime: String
    let homeTeam, awayTeam: String
    let bookmakers: [Bookmaker]

    enum CodingKeys: String, CodingKey {
        
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
}

extension Odds {
    
    var eventTitle: String {
        return "\(homeTeam) - \(awayTeam)"
    }
}

struct Bookmaker: Decodable {
    
    let key, title: String
    let markets: [Market]
    let link: String?
    let sid: String?
}

struct Market: Decodable {
    
    let key: String
    let lastUpdate: String
    let outcomes: [Outcome]
    let link: String?
    let sid: String?

    enum CodingKeys: String, CodingKey {
        
        case key
        case lastUpdate = "last_update"
        case outcomes, link, sid
    }
}

struct Outcome: Decodable {
    
    let name: String
    let price, point: Double
}

