//
//  Reusable.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

/// Protocol to conform when supplying a reuse identifier
public protocol Reusable {

    static var reuseIdentifier: String { get }
    var reuseIdentifier: String { get }
}

public extension Reusable {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

    var reuseIdentifier: String {
        return type(of: self).reuseIdentifier
    }
}
