//
//  EventsViewModelTests.swift
//  iOSBilyonerCaseTests
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import XCTest
@testable import iOSBilyonerCase
import RxSwift
import RxCocoa

final class EventsViewModelTests: XCTestCase {

    var viewModel: EventsViewModel!
    var viewModelForError: EventsViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        viewModel = EventsViewModel(provider: MockBetAPIService(errorStatus: false),
                                    sport: Sport(key: "Football",
                                                 group: "",
                                                 title: "Football",
                                                 description: "",
                                                 active: true,
                                                 hasOutrights: true))
        viewModelForError = EventsViewModel(provider: MockBetAPIService(errorStatus: true),
                                            sport: Sport(key: "Football",
                                                         group: "",
                                                         title: "Football",
                                                         description: "",
                                                         active: true,
                                                         hasOutrights: true))
        
        let mockElements: [BaseCellDataProtocol] = [
            EventsTableViewCellViewModel(event: Event(id: "",
                                                      sportKey: "",
                                                      sportTitle: "Football",
                                                      commenceTime: "",
                                                      homeTeam: "Besiktas",
                                                      awayTeam: "Galatasaray"),
                                         title: "Football"),
            EventsTableViewCellViewModel(event: Event(id: "",
                                                      sportKey: "",
                                                      sportTitle: "Football",
                                                      commenceTime: "",
                                                      homeTeam: "Fenerbahçe",
                                                      awayTeam: "Trabzonspor"),
                                         title: "Football"),
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
        viewModel.testableFilterContent(query: "Besik")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 1)
        XCTAssertEqual((filteredItems.first as? EventsTableViewCellViewModel)?.event.sportTitle, "Football")
    }
    
    func testFilterContent_whenQueryMatches_shouldReturnFilteredElements() {
        viewModel.testableFilterContent(query: "Besiktas")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 1)
        XCTAssertEqual((filteredItems.first as? EventsTableViewCellViewModel)?.event.sportTitle, "Football")
    }
    
    func testFilterContent_whenQueryNotMatches_shouldReturnEmptyElements() {
        viewModel.testableFilterContent(query: "Göztepe")
        let filteredItems = viewModel.getBehaviourElements().value
        
        XCTAssertEqual(filteredItems.count, 0)
        XCTAssertNotEqual((filteredItems.first as? EventsTableViewCellViewModel)?.event.sportTitle, "Football")
    }
}
