//
//  BetAPI.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Moya
import Foundation

enum BetAPI {
    
    case sports
    case events(sportKey: String)
    case eventOdds(eventId: String, sportKey: String)
}

extension BetAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.the-odds-api.com/v4")!
    }

    var path: String {
        switch self {
        case .sports:
            return "/sports"
        case .events(let sportKey):
            return "sports/\(sportKey)/events"
        case .eventOdds(let eventId, let sportKey):
            return "sports/\(sportKey)/events/\(eventId)/odds"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .sports, .events, .eventOdds:
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

// MARK: - Parameters

extension BetAPI {

    var parameters: [String: Any] {
        var params: [String: Any] = [
            "apiKey": "facd201a0f5b6b5c0f102f2258611ac4"
        ]
        params["regions"] = "us"
        params["dateFormat"] = "iso"
        params["oddsFormat"] = "decimal"

        switch self {
        case .sports:
            return params
        case .events:
            params["markets"] = "h2h"
        case .eventOdds:
            params["markets"] = "player_pass_tds,alternate_spreads"
        }
        return params
    }
}
