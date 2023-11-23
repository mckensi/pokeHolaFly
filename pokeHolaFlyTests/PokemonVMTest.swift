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
    
    private var subscribers = Set<AnyCancellable>()
    
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
  
        let expectation = XCTestExpectation(description: "fnish")
        vm.$pokemons
            .dropFirst()
            .sink { pokemons in
                if !pokemons.isEmpty {
                    XCTAssertTrue(!pokemons.isEmpty)
                    XCTAssertEqual(pokemons.first?.name, "caterpie")
                    XCTAssertEqual(pokemons.last?.name, "pikachu")
                    XCTAssertEqual(pokemons.count, 2)
                    expectation.fulfill()
                }
   
        }
        .store(in: &subscribers)
        
        vm.testHooks.getPokemons()

        wait(for: [expectation], timeout: 1)
        
        
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

        let expectation = XCTestExpectation(description: "fnish")
        vm.$pokemons
            .dropFirst()
            .sink { pokemons in
                if !pokemons.isEmpty {
                    XCTAssertTrue(!pokemons.isEmpty)
                    XCTAssertEqual(pokemons.first?.name, "caterpie")
                    XCTAssertEqual(pokemons.last?.name, "pikachu")
                    XCTAssertEqual(pokemons.count, 2)
                    expectation.fulfill()
                }
   
        }
        .store(in: &subscribers)
        
        vm.testHooks.getPokemonsWithPages(offset: 1)

        wait(for: [expectation], timeout: 1)
    }
}

