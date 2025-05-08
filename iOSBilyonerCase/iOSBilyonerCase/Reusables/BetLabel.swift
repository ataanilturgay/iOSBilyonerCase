//
//  BetLabel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 9.05.2025.
//

import UIKit

final class BetLabel: UILabel {
    
    // MARK: - Initializer
    
    init(fontSize: CGFloat = BetStyling.TextSize.body.size, textColor: UIColor = .black, alignment: NSTextAlignment = .left, numberOfLines: Int = 0) {
        super.init(frame: .zero)
        
        configure(fontSize: fontSize,
                  textColor: textColor,
                  alignment: alignment,
                  numberOfLines: numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Configuration
    private func configure(fontSize: CGFloat = BetStyling.TextSize.body.size,
                           textColor: UIColor = .black,
                           alignment: NSTextAlignment = .left,
                           numberOfLines: Int = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = textColor
        self.font = .systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
        self.textAlignment = alignment
    }
}
