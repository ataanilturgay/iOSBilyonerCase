//
//  EventDetailProviderTableViewCellViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import RxCocoa

final class EventDetailProviderTableViewCellViewModel: BaseCellViewModel {

    let betProviders = BehaviorRelay<[Bookmaker]>(value: [])

    init(betProviders: [Bookmaker], title: String) {

        self.betProviders.accept(betProviders)
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension EventDetailProviderTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {

        return String(describing: EventDetailProviderTableViewCell.self)
    }

    var reuseIdentifier: String {

        return EventDetailProviderTableViewCellViewModel.reuseIdentifier
    }
}
