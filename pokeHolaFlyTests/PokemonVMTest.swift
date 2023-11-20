//
//  PokemonVMTest.swift
//  pokeHolaFlyTests
//
//  Created by Alex Murcia on 19/11/23.
//

import Foundation
@testable import pokeHolaFly
import XCTest
import Combine

final class PokemonVMTest: XCTestCase {
    private var vm: PokemonsVM?
    
    override func setUpWithError() throws {
        vm = PokemonsVM(network: DataTest())
    }

    override func tearDownWithError() throws {
       vm = nil
    }

    func testGetPokemons() {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }
  
        vm.testHooks.getPokemons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(vm.alertMsg, "")
            XCTAssertFalse(vm.showAlert)
            XCTAssertTrue(!vm.pokemons.isEmpty)
            XCTAssertEqual(vm.pokemons.count, 2)
            XCTAssertEqual(vm.pokemons.first?.name, "bulbasaur")
            XCTAssertEqual(vm.pokemons.last?.name, "ivysaur")
            
            XCTAssertTrue(!vm.testHooks.pokemonsDownloaded.isEmpty)
            XCTAssertEqual(vm.testHooks.pokemonsDownloaded.count, 2)
            XCTAssertEqual(vm.testHooks.pokemonsDownloaded.first?.name, "bulbasaur")
            XCTAssertEqual(vm.testHooks.pokemonsDownloaded.last?.name, "ivysaur")
        }
     
    }
    
    func testGetPokemonsNextPageEmpty() {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }

        vm.testHooks.getPokemonsWithPages(offset: 1)
        XCTAssertTrue(vm.pokemons.isEmpty)
    }
    
    func testGetPokemonsNextPageWithPreviewPokemos() {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }
        
        vm.testHooks.getPokemons()
        vm.testHooks.getPokemonsWithPages(offset: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            XCTAssertEqual(vm.alertMsg, "")
            XCTAssertFalse(vm.showAlert)
            XCTAssertTrue(!vm.pokemons.isEmpty)
            XCTAssertEqual(vm.pokemons.count, 2)
            XCTAssertEqual(vm.pokemons.first?.name, "bulbasaur")
            XCTAssertEqual(vm.pokemons.last?.name, "ivysaur")
            
            XCTAssertTrue(!vm.testHooks.pokemonsDownloaded.isEmpty)
            XCTAssertEqual(vm.testHooks.pokemonsDownloaded.count, 2)
            XCTAssertEqual(vm.testHooks.pokemonsDownloaded.first?.name, "bulbasaur")
        }
    }
}

