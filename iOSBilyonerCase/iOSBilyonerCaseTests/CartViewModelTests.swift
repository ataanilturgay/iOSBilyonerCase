//
//  CartViewModelTests.swift
//  iOSBilyonerCaseTests
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import XCTest
@testable import iOSBilyonerCase
import RxSwift
import RxCocoa

final class CartViewModelTests: XCTestCase {
    
    var viewModel: CartViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = CartViewModel(provider: MockBetAPIService(errorStatus: false))
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        disposeBag = nil
    }
    
    func testGetCart_whenItemExists_shouldReturnNotEmpty() {
        CartManager.shared.addItem(item: Cart(id: "1", title: "Test Item", price: 5.0, point: 1, teams: ""))
        viewModel.getCart()
        
        XCTAssertNotEqual(viewModel.getElements().count, 0)
        XCTAssertEqual(viewModel.getElements().count, 1)
        XCTAssertEqual((viewModel.getElements().first as? CartTableViewCellViewModel)?.cart.title, "Test Item")
    }
    
    func testGetCart_whenCartIsEmpty_shouldReturnEmpty() {
        CartManager.shared.addItem(item: Cart(id: "1", title: "Test Item", price: 5.0, point: 1, teams: ""))
        CartManager.shared.clearItems()
        viewModel.getCart()

        XCTAssertEqual(viewModel.getElements().count, 0)
    }
    
    func testCalculateCartTotal_whenItemsAdded_shouldReturnCorrectTotal() {
        let item1 = Cart(id: "1", title: "Test Item 1", price: 5.0, point: 2, teams: "")
        let item2 = Cart(id: "2", title: "Test Item 2", price: 5.0, point: 3, teams: "")
        
        CartManager.shared.addItem(item: item1)
        CartManager.shared.addItem(item: item2)
        
        let total = CartManager.shared.calculateCartTotal()
        XCTAssertEqual(total, 25, accuracy: 0.001)
    }
}
