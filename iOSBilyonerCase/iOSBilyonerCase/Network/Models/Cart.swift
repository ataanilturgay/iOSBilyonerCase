//
//  Cart.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import Foundation

struct Cart {
    
    let id: String
    let title: String
    let price: Double
    let point: Double
    let teams: String
}

extension Cart: Equatable {
    
    static func ==(lhs: Cart, rhs: Cart) -> Bool {
        return lhs.id == rhs.id
    }
}
