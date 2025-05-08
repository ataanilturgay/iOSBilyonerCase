//
//  Constants.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

enum Global {
 
    enum Constants {

        enum ErrorView {
            
            static let delay: Int = 100 // milliseconds
        }
        
        enum Styling {
            
            static let textColor: UIColor = .black
            static let font: UIFont = .systemFont(ofSize: 14)
            static let cornerRadius: CGFloat = 8.0
            static let borderWidth: CGFloat = 1.0
            static let borderColor: UIColor = .primaryBackgroundColor
        }
        
        enum Constraints {
            
            static let defaultPadding: CGFloat = 16.0
        }
        
        enum Images {
            
            static let close: String = "xmark"
        }
    }
}
