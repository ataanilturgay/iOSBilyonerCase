//
//  CartManager.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 7.05.2025.
//

import Foundation
import RxSwift
import RxCocoa

final class CartManager {
    
    static let shared = CartManager()
    private init() {}
    
    let cartItemCount = BehaviorRelay<Int>(value: 0)
    let items = BehaviorRelay<[Cart]>(value: [])
    let cartTotal = BehaviorRelay<Double>(value: 0)

    func addItem(item: Cart) {
        var currentItems = items.value
        currentItems.append(item)
        items.accept(currentItems)
        cartItemCount.accept(items.value.count)
        AnalyticsManager.shared.sendEvent(event: .addToCart)
    }
    
    func removeItem(index: Int) {
        var currentItems = items.value
        if index >= currentItems.count {
            return
        }
        currentItems.remove(at: index)
        items.accept(currentItems)
        cartItemCount.accept(max(cartItemCount.value - 1, 0))
        AnalyticsManager.shared.sendEvent(event: .removeFromCart)
    }
    
    func removeItem(item: Cart) {
        var currentItems = items.value
        if currentItems.contains(where: { $0.id == item.id }) {
            guard let index = currentItems.firstIndex(of: item) else { return }
            currentItems.remove(at: index)
            items.accept(currentItems)
            cartItemCount.accept(max(cartItemCount.value - 1, 0))
            AnalyticsManager.shared.sendEvent(event: .removeFromCart)
        }
    }
    
    func calculateCartTotal() -> Double {
        let total = items.value.reduce(1.0) { result, item in
            return result * (item.price)
        }
        return Double(round(1000 * total) / 1000)
    }
    
    func clearItems() {
        var currentItems = items.value
        currentItems.removeAll()
        items.accept(currentItems)
    }
}
