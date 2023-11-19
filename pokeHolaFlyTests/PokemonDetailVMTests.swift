//
//  PokemonDetailVMTests.swift
//  pokeHolaFlyTests
//
//  Created by Alex Murcia on 19/11/23.
//

import Foundation
@testable import pokeHolaFly
import XCTest

final class PokemonDetailVMTest: XCTestCase {
    
    private var vm: PokemonDetailVM?
    
    override func setUpWithError() throws {
        vm = PokemonDetailVM(network: DataTest(), pokemon: .test)
    }

    override func tearDownWithError() throws {
       vm = nil
    }

    func testGetPokemons() async {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }
        
        await vm.testHooks.getMovesDetails()
        
        XCTAssertFalse(vm.showAlert)
        XCTAssertTrue(vm.alertMsg.isEmpty)
        XCTAssertFalse(vm.movesDetails.isEmpty)
        XCTAssertEqual(vm.movesDetails.count, 2)
    }
}
