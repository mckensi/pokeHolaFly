//
//  PokemonVMTest.swift
//  pokeHolaFlyTests
//
//  Created by Alex Murcia on 19/11/23.
//

import Foundation
@testable import pokeHolaFly
import XCTest

final class PokemonVMTest: XCTestCase {
    
    private var vm: PokemonsVM?
    
    override func setUpWithError() throws {
        vm = PokemonsVM(network: DataTest())
    }

    override func tearDownWithError() throws {
       vm = nil
    }

    func testGetPokemons() async {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }
        
        await vm.testHooks.getPokemons()
        
        XCTAssertEqual(vm.alertMsg, "")
        XCTAssertFalse(vm.showAlert)
        XCTAssertTrue(!vm.pokemons.isEmpty)
        XCTAssertEqual(vm.pokemons.count, 2)
        XCTAssertEqual(vm.pokemons.first?.name, "caterpie")
        XCTAssertEqual(vm.pokemons.last?.name, "pikachu")
        
        XCTAssertTrue(!vm.testHooks.pokemonsDownloaded.isEmpty)
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.count, 2)
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.first?.name, "caterpie")
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.last?.name, "pikachu")
    }
    
    func testGetPokemonsNextPageWithPreviewPokemos() async {
        guard let vm = vm else {
            XCTFail("vm can not be created")
            return
        }

        await vm.testHooks.getPokemons()
        await vm.testHooks.getPokemonsWithPages(offset: 1)
      
        XCTAssertEqual(vm.alertMsg, "")
        XCTAssertFalse(vm.showAlert)
        XCTAssertTrue(!vm.pokemons.isEmpty)
        XCTAssertEqual(vm.pokemons.count, 4)
        XCTAssertEqual(vm.pokemons.first?.name, "caterpie")
        XCTAssertEqual(vm.pokemons.last?.name, "pikachu")
        
        XCTAssertTrue(!vm.testHooks.pokemonsDownloaded.isEmpty)
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.count, 4)
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.first?.name, "caterpie")
        XCTAssertEqual(vm.testHooks.pokemonsDownloaded.last?.name, "pikachu")
    }
}

