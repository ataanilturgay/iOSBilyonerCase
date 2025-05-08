//
//  Constants.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

enum Global {
 
    enum Constants {
        
        static let searchPlaceholder: String = "Ara"
        static let cancelText: String = "Vazgeç"
        static let addToCartText: String = "Kupona Ekle"
        
        enum ErrorView {
            
            static let delay: Int = 100 // milliseconds
        }
        
        enum Styling {
            
            static let textColor: UIColor = .black
            static let fontSize: CGFloat = 14.0
            static let cornerRadius: CGFloat = 8.0
            static let borderWidth: CGFloat = 1.0
            static let borderColor: UIColor = .primaryBackgroundColor
        }
        
        enum Constraints {
            
            //static let defaultPadding: CGFloat = 16.0
        }
        
        enum Images {
            
            static let close: String = "xmark"
        }
        
        enum Pages {
            
            static let sports: String = "Kategoriler"
            static let events: String = "Etkinlikler"
            static let eventDetail: String = "Detay"
            static let cart: String = "Kupon"
        }
    }
}
