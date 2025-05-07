//
//  SportsTablViewCellViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 6.05.2025.
//

import RxSwift
import RxCocoa

final class SportsTableViewCellViewModel: BaseCellViewModel {

    let sport: Sport
    let title: Driver<String>

    init(sport: Sport, title: String, shouldShowTitle: Bool = false) {

        self.sport = sport
        self.title = Driver.just(sport.title)
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension SportsTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {

        return String(describing: SportsTableViewCell.self)
    }

    var reuseIdentifier: String {

        return SportsTableViewCellViewModel.reuseIdentifier
    }
}
