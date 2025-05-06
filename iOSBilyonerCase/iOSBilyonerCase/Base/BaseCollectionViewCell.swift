//
//  BaseCollectionViewCell.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell, Reusable {

    var disposeBag = DisposeBag()

    override func awakeFromNib() {

        super.awakeFromNib()
        applyStyling()
    }

    override func prepareForReuse() {

        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(to viewModel: BaseCellViewModel) {

        // subclasses should override
    }

    func bind(withProtocol viewModel: BaseCellDataProtocol) {

        // subclasses should override
    }

    func applyStyling() {

        // subclasses should override and call super
        backgroundColor = .clear
    }
}
