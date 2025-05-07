//
//  UICollectionView+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit

extension UICollectionView {
    
    func registerClassCell<T: UICollectionViewCell & Reusable>(type: T.Type) {
        register(type.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    func bind(providers: [BaseCellDataProtocol]) {
        // reloadData veya daha gelişmiş binding yapılır burada
    }
}
