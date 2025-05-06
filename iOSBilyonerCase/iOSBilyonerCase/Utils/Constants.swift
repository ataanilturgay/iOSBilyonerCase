//
//  Constants.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

import UIKit

enum Global {

    enum Storyboard {

        enum Events {
            
            static let name = "Main"
        }

        enum Search {
            static let name = "Search"
        }
    }
    
    enum Url {
        enum Base {
            static let devUrl: String = "https://develop.blutv.com/configs"
            static let stageUrl: String = "https://stage.blutv.com/configs"
            static let prodUrl: String = "https://www.blutv.com/configs"
            static let beta1Url: String = "https://beta1.blutv.com/configs"
        }
        
        enum Account {
            static let supportUrl: String = "https://destek.blutv.com/hc/tr/requests/new"
            static let subscriptionAgreementUrl: String = "https://www.blutv.com/uyelik-sozlesmesi?code=TR_USER_V1"
        }
    }

    enum Key {

        enum Mux {

            static let environment = "s8ttlilfhge6skqdq10uk6q98"
        }

        enum Adjust {

            static let token = "t2fytpzlmsqo"
        }

        
        enum OneTrust {
            
            static let storageLocation: String = "cdn.cookielaw.org"
            static let domainIdentifier: String = "edefaa1f-9067-4897-bc13-eeb94d8d1d39"
            
            enum Language {
                
                static let tr: String = "tr"
                static let ar: String = "ar"
            }
        }
    }
 
    enum Constants {

        enum Default {

            static let cornerRadius: CGFloat = 3.0
            static let visibilityAnimationDuration: TimeInterval = 0.25
            static let pageViewControllerTransitionUILockDuration: TimeInterval = 2.0
        }

        enum ErrorView {

            static let delay: Int = 300 // milliseconds
        }

        enum EmptyView {

            static let delay: Int = 200 // milliseconds
        }

        enum SimilarDetail {

            static let delay: Int = 300 // milliseconds
        }


        enum CollectionView {

            static let promoSerieCount: CGFloat = 1 //isIpad ? 2 : 1
        }


        enum Search {

            static let borderWith: CGFloat = 1.0
            static let animationDuration: TimeInterval = 0.25
            static let cornerRadius: CGFloat = 5.0

            enum Focused {

                static let borderColor: UIColor = .white
            }

            enum Unfocused {

                static let borderColor: UIColor = .clear
            }
        }
    }
}
