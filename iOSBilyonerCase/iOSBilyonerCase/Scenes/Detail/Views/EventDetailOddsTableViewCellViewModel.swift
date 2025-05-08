//
//  EventDetailOddsTableViewCellViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import RxSwift
import RxCocoa

final class EventDetailOddsTableViewCellViewModel: BaseCellViewModel {

    let odds: Odds
    let outcome: Outcome
    let title: String
    let teams: String

    init(odds: Odds, outcome: Outcome, shouldShowTitle: Bool = false) {
        self.odds = odds
        self.outcome = outcome
        self.title = "\(outcome.name) - (\(outcome.point)) - \(outcome.price)"
        self.teams = "\(odds.homeTeam) - \(odds.awayTeam)"
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension EventDetailOddsTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {
        return String(describing: EventDetailOddsTableViewCell.self)
    }

    var reuseIdentifier: String {
        return EventDetailOddsTableViewCellViewModel.reuseIdentifier
    }
}
