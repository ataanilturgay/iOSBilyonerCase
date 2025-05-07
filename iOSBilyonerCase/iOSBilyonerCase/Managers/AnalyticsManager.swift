//
//  AnalyticsManager.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import FirebaseAnalytics

enum EventNames: String {
    
    case eventDetail = "event_detail"
    case addToCart = "add_to_cart"
    case removeFromCart = "remove_from_cart"
}

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    private init() { }
    
    func sendEvent(event: EventNames) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
}
