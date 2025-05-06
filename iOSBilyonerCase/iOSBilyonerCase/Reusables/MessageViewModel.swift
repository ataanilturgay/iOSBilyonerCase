//
//  MessageViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

final class MessageViewModel: BaseCellViewModel {

    let title: String?
    let message: String

    init(title: String? = nil,
         message: String) {

        self.title = title
        self.message = message
    }
}
