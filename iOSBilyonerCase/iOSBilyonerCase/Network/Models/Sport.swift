//
//  Sport.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import Foundation

struct Sport: Decodable {
    
    let key, group, title: String
    let description: String
    let active: Bool
    let hasOutrights: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case key
        case group
        case title
        case description
        case active
        case hasOutrights = "has_outrights"
    }
}
