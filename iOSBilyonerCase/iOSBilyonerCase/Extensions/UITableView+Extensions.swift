//
//  UITableView+Extensions.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import UIKit

extension UITableView {
    
    func registerClassCell<T: UITableViewCell & Reusable>(type: T.Type) {
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }
}
