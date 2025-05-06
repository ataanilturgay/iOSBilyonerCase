//
//  EventDetailTableViewCellViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import RxSwift
import RxCocoa

final class EventDetailTableViewCellViewModel: BaseCellViewModel {

    let odd: Odd
    let title: Driver<String>
    let teams: Driver<String>

    init(odd: Odd, title: String, shouldShowTitle: Bool = false) {

        self.odd = odd
        self.title = Driver.just(odd.sportTitle)
        self.teams = Driver.just("\(odd.homeTeam) - \(odd.awayTeam)")
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension EventDetailTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {

        return String(describing: EventDetailTableViewCell.self)
    }

    var reuseIdentifier: String {

        return EventDetailTableViewCellViewModel.reuseIdentifier
    }
}
