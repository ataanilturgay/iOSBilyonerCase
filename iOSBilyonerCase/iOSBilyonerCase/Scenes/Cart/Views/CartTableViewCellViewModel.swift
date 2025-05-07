//
//  CartTableViewCellViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import RxSwift
import RxCocoa

final class CartTableViewCellViewModel: BaseCellViewModel {

    let cart: Cart
    let title: Driver<String>
    let teams: Driver<String>
    init(cart: Cart) {

        self.cart = cart
        self.title = Driver.just(cart.title)
        self.teams = Driver.just(cart.teams)
        super.init()
    }
}

// MARK: - BaseCellDataProtocol

extension CartTableViewCellViewModel: BaseCellDataProtocol {

    static var reuseIdentifier: String {
        return String(describing: CartTableViewCell.self)
    }

    var reuseIdentifier: String {
        return CartTableViewCellViewModel.reuseIdentifier
    }
}
