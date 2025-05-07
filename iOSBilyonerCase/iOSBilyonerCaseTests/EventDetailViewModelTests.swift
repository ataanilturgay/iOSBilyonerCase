//
//  EventDetailViewModelTests.swift
//  iOSBilyonerCaseTests
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import XCTest
@testable import iOSBilyonerCase
import RxSwift
import RxCocoa

final class EventDetailViewModelTests: XCTestCase {
    
    var viewModel: EventDetailViewModel!
    var mockService: MockBetAPIService!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockService = MockBetAPIService()
        disposeBag = DisposeBag()
        
        let event = iOSBilyonerCase.Event(id: "1", sportKey: "soccer", sportTitle: "Soccer Match", commenceTime: "", homeTeam: "Besiktas", awayTeam: "Fenerbahce")
        viewModel = EventDetailViewModel(provider: mockService, event: event)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_loadTrigger_fetchesEventsSuccessfully() {
        // Arrange
        let expectedEvents = [iOSBilyonerCase.Event(id: "1", sportKey: "soccer", sportTitle: "Soccer Match", commenceTime: "", homeTeam: "Galatasaray", awayTeam: "Fenerbahce")]
        mockService.mockEvents = expectedEvents
        
        let input = EventDetailViewModel.Input(loadTrigger: Observable.just(()), selectedProviderIndex: Observable.just(0))
        let output = viewModel.transform(input: input)
    }
}

final class MockBetAPIService: BetAPIService {
    
    var shouldReturnError = false
    var mockSports: [iOSBilyonerCase.Sport] = []
    var mockEvents: [iOSBilyonerCase.Event] = []
    var mockOdds: Odds?
    
    func getSports() -> Single<[Sport]> {
        if shouldReturnError {
            return .error(ApiError.network)
        }
        return Observable.just(mockSports).asSingle()
    }
    
    func getEvents(sportKey: String) -> Single<[iOSBilyonerCase.Event]> {
        if shouldReturnError {
            return .error(ApiError.network)
        }
        return Observable.just(mockEvents).asSingle()
    }
    
    func getEventOdds(id: String, sportKey: String) -> Single<Odds> {
        if shouldReturnError {
            return .error(ApiError.network)
        }
        guard let odds = mockOdds else {
            return .error(ApiError.unknown)
        }
        return Observable.just(odds).asSingle()
    }
}

struct MockData {
    
    static let event = iOSBilyonerCase.Event(id: "1", sportKey: "soccer", sportTitle: "Soccer Match", commenceTime: "", homeTeam: "Galatasaray", awayTeam: "Fenerbahce")
}
