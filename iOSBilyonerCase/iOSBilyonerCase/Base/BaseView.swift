//
//  BaseView.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 5.05.2025.
//

import Foundation

import UIKit
import RxSwift

class BaseView: UIView {

    var disposeBag = DisposeBag()

    override func awakeFromNib() {

        super.awakeFromNib()
        applyStyling()
    }

    func bind(to viewModel: BaseCellViewModel) {

        // subclasses should override
    }

    func applyStyling() {

        // subclasses should override and call super
    }
}
