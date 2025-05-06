//
//  StoryboardBased.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

public protocol StoryboardBased: Reusable {

    static var storyboardName: String { get }
}

public extension StoryboardBased {

    static func instantiate() -> Self {

        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: reuseIdentifier) as? Self else {
            fatalError(reuseIdentifier + " cannot be instantiated via storyboard")
        }

        return viewController
    }
}
