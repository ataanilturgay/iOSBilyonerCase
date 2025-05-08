//
//  Event.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

struct Event: Decodable {
    
    let id, sportKey, sportTitle: String
    let commenceTime: String
    let homeTeam: String?
    let awayTeam: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}
