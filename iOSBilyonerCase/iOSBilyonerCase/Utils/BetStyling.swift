//
//  Styling.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 9.05.2025.
//

import UIKit

struct BetStyling {

    enum Spacing {

        static let xsmall: CGFloat = 6.0
        static let small: CGFloat = 12.0
        static let medium: CGFloat = 16.0
        static let large: CGFloat = 32.0
    }

    enum TextSize {

        case bigHeader
        case xlargeHeader
        case largeHeader
        case header3
        case header2
        case header1
        case header
        case title
        case subtitle
        case body
        case small
        case hint

        var size: CGFloat {

            switch self {

            case .bigHeader:
                return 50.0
            case .xlargeHeader:
                return 40.0
            case .largeHeader:
                return 34.0
            case .header3:
                return 32.0
            case .header2:
                return 28.0
            case .header1:
                return 24.0
            case .header:
                return 20.0
            case .title:
                return 18.0
            case .subtitle:
                return 16.0
            case .body:
                return 14.0
            case .small:
                return 12.0
            case .hint:
                return 10.0
            }
        }
    }
}
