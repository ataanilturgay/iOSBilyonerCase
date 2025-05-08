//
//  MockTestViewModel.swift
//  iOSBilyonerCase
//
//  Created by Ata Anıl Turgay on 8.05.2025.
//

import RxCocoa

protocol MockTestViewModel {
    
    func testableFilterContent(query: String)
    func testableSetElements(elements: [BaseCellDataProtocol])
    func testableSetBehaviourElements(elements: [BaseCellDataProtocol])
    func getElements() -> [BaseCellDataProtocol]
    func getBehaviourElements() -> BehaviorRelay<[BaseCellDataProtocol]>
}
