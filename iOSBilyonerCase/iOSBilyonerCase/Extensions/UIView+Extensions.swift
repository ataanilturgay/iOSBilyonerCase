//
//  UIView+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

public extension UIView {

    /// Apply shadow to view
    ///
    /// - Parameters:
    ///   - opacity: Opacity to be applied (defaults to 0)
    ///   - radius: Radius to be applied (defaults to 3)
    ///   - offset: Offset to be applied (defaults to .zero)
    ///   - color: Color to be applied (defaults to black)
    func applyShadow(
        opacity: Float = 0.0,
        radius: CGFloat = 3.0,
        offset: CGSize = .zero,
        color: CGColor = UIColor.black.cgColor
        ) {

        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
}
