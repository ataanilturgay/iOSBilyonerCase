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

final class SportsViewModelTests: XCTestCase {

    var viewModel: SportsViewModel!
    var viewModelForError: SportsViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = SportsViewModel(provider: MockBetAPIService(errorStatus: false))
        viewModelForError = SportsViewModel(provider: MockBetAPIService(errorStatus: true))
        
        let mockElements: [BaseCellDataProtocol] = [
            SportsTableViewCellViewModel(sport: Sport(key: "Football",
                                                      group: "",
                                                      title: "Football",
                                                      description: "",
                                                      active: true,
                                                      hasOutrights: true), title: "Football"),
            SportsTableViewCellViewModel(sport: Sport(key: "Basketball",
                                                      group: "",
                                                      title: "Basketball",
                                                      description: "",
                                                      active: true,
                                                      hasOutrights: true), title: "Basketball")
        ]
        
        viewModel.testableSetElements(elements: mockElements)
        viewModel.testableSetBehaviourElements(elements: mockElements)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        viewModelForError = nil
        disposeBag = nil
    }

    func testGetSports_whenDataExists_shouldReturnNotEmpty() {
        let expectation = expectation(description: "Fetch sports from mock API")
        viewModel.provider.getSports()
            .subscribe(onSuccess: { sports in
                XCTAssertNotEqual(sports.count, 0)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetSports_whenDataNoExists_shouldReturnEmpty() {
        let expectation = expectation(description: "Fetch sports from mock API")
        viewModelForError.provider.getSports()
            .subscribe(onSuccess: { sports in
                XCTAssertEqual(sports.count, 0)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterContent_whenQueryIsEmpty_shouldReturnAllElements() {
        viewModel.testableFilterContent(query: "")
        let expectedCount = viewModel.getElements().count
        
        XCTAssertEqual(viewModel.getBehaviourElements().value.count, expectedCount)
    }
    
    func testFilterContent_whenQueryContains_shouldReturnFilteredElements() {
        viewModel.testableFilterContent(query: "Foot")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 1)
        XCTAssertEqual((filteredItems.first as? SportsTableViewCellViewModel)?.sport.title, "Football")
    }
    
    func testFilterContent_whenQueryMatches_shouldReturnFilteredElements() {
        viewModel.testableFilterContent(query: "Football")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 1)
        XCTAssertEqual((filteredItems.first as? SportsTableViewCellViewModel)?.sport.title, "Football")
    }
    
    func testFilterContent_whenQueryNotMatches_shouldReturnEmptyElements() {
        viewModel.testableFilterContent(query: "AAAA")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 0)
        XCTAssertNotEqual((filteredItems.first as? SportsTableViewCellViewModel)?.sport.title, "Football")
    }
}
