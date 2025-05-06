//
//  EventsCollectionViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import RxSwift
import RxCocoa

final class EventsTableViewCellViewModel: BaseCellViewModel {

    let event: Event
    let title: Driver<String>
    let teams: Driver<String>
    let searchText: String

    init(event: Event, title: String, shouldShowTitle: Bool = false) {

        self.event = event
        self.title = Driver.just(event.sportTitle)
        self.teams = Driver.just("\(event.homeTeam) - \(event.awayTeam)")
        self.searchText = "\(event.homeTeam) - \(event.awayTeam)"
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension EventsTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {

        return String(describing: EventsTableViewCell.self)
    }

    var reuseIdentifier: String {

        return EventsTableViewCellViewModel.reuseIdentifier
    }
}
