//
//  UIApplication+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import UIKit

extension UIApplication {
    
    var currentKeyWindow: UIWindow? {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
