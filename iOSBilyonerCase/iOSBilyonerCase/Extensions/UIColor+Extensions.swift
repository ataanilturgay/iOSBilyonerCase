//
//  UIColor+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit

extension UIColor {

    static func from(hex string: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        return hexString.count == 6 ? hextToRgb(hex: hexString, alpha: alpha) : hextToRgba(hex: hexString)
    }

    static func hextToRgb(hex string: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var colorValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        
        if scanner.scanHexInt64(&colorValue) {
            let r = (colorValue & 0xFF0000) >> 16
            let g = (colorValue & 0x00FF00) >> 8
            let b = (colorValue & 0x0000FF)

            return UIColor(red: CGFloat(r) / 255.0,
                           green: CGFloat(g) / 255.0,
                           blue: CGFloat(b) / 255.0,
                           alpha: alpha)
        }
        
        return UIColor.clear
    }

    static func hextToRgba(hex string: String) -> UIColor {
        var hexString = string
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var colorValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        
        if scanner.scanHexInt64(&colorValue) {
            let r = (colorValue & 0xFF000000) >> 24
            let g = (colorValue & 0x00FF0000) >> 16
            let b = (colorValue & 0x0000FF00) >> 8
            let a = (colorValue & 0x000000FF)

            return UIColor(red: CGFloat(r) / 255.0,
                           green: CGFloat(g) / 255.0,
                           blue: CGFloat(b) / 255.0,
                           alpha: CGFloat(a) / 255.0)
        }
        
        return UIColor.clear
    }
    
    class var primaryBackgroundColor: UIColor {
        return .from(hex: "#1baa52")
    }
}

