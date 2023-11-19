//
//  PokemonsVM.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

final class PokemonsVM: ObservableObject {
    let network: DataInteractor
    
    @Published var pokemons: [Pokemon] = []
    @Published var alertMsg: String = ""
    @Published var showAlert: Bool = false
     
    private var pokemonsDownloaded: [Pokemon] = []
    
    var currentOffset = 0
    
    init(network: DataInteractor = Network()) {
        self.network = network
        
        Task { await getPokemons() }
    }
    
    private func getPokemons() async {
        do {
            let pokemons = try await network.getPokemonsList(offset: 0)
            await MainActor.run {
                self.pokemons = pokemons.sorted { $0.id < $1.id }
                self.pokemonsDownloaded = pokemons.sorted { $0.id < $1.id }
            }
        } catch {
            print(error)
            await MainActor.run {
                self.alertMsg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    
    private func getPokemonsWithPages(offset: Int) async {
        do {
            let newPokemons = try await network.getPokemonsList(offset: offset).sorted { $0.id < $1.id }
            await MainActor.run {
                self.pokemons.append(contentsOf: newPokemons)
                self.pokemonsDownloaded.append(contentsOf: newPokemons)
            }
        } catch {
            print(error)
            await MainActor.run {
                self.alertMsg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    
    func shouldCallNextPageOfPokemons(pokemon: Pokemon) {
        if pokemons.last?.id == pokemon.id {
            currentOffset += 20
            Task {
                await getPokemonsWithPages(offset: currentOffset)
            }

        }
    }
    
    func searchPokemons(search: String) {
        if search == "" {
            pokemons = pokemonsDownloaded
        } else {
            let pokemonsFiltered = pokemonsDownloaded.filter { $0.name.contains(search.lowercased()) }
            pokemons = pokemonsFiltered
            
            if pokemons.count == 0 {
                Task {
                    await searchPokemonsFromApy(search: search)
                }
            }
        }
    }
    
    private func searchPokemonsFromApy(search: String) async {
        do {
            let pokemonSearch = try await network.searchPokemon(search: search)
            guard let pokemonSearch else {
                return
            }
            
            await MainActor.run {
                pokemons.append(pokemonSearch)
            }
        } catch {
            print(error)
        }
    }
}

#if DEBUG
extension PokemonsVM {
    var testHooks: TestHooks {
        return TestHooks(target: self)
    }
    
    struct TestHooks {
        private let target: PokemonsVM
        
        fileprivate init(target: PokemonsVM) {
            self.target = target
        }
        
        var pokemonsDownloaded: [Pokemon] {
            target.pokemonsDownloaded
        }
        
        func getPokemons() async {
            await target.getPokemons()
        }
        
        func getPokemonsWithPages(offset: Int) async {
            await target.getPokemonsWithPages(offset: offset)
        }
    }
}
#endif
