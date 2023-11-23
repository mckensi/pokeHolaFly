//
//  PokemonsVM.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI
import Combine

final class PokemonsVM: ObservableObject {
    let network: DataInteractor
    
    @Published var pokemons: [Pokemon] = []
    @Published var alertMsg: String = ""
    @Published var showAlert: Bool = false
     
    private var pokemonsDownloaded: [Pokemon] = []
    
    var currentOffset = 0
    
    private var subscribers = Set<AnyCancellable>()
    
    init(network: DataInteractor = Network()) {
        self.network = network
        getPokemons()
    }
    
    private func getPokemons() {
        network.getPokemonsListPublisher(offset: 0)
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { pokemonList in
                self.getEveryPokemonOnList(pokemonList: pokemonList)
            }
            .store(in: &self.subscribers)
    }
    
    private func getEveryPokemonOnList(pokemonList: PokemonListDto) {
        let publishers: [AnyPublisher<PokemonDto, Error>] = pokemonList.results.map { pokemon in
            network.getPokemonPublisher(url: pokemon.url)
        }
        
        let publisherMerged = Publishers.MergeMany(publishers)
        
        publisherMerged
            .collect()
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { pokemonsDto in
                let pokemonsDto = pokemonsDto.map { $0.toPresentation }.sorted { $0.id < $1.id }
                DispatchQueue.main.async {
                    self.pokemons = pokemonsDto
                    self.pokemonsDownloaded = pokemonsDto
                }

            }
            .store(in: &subscribers)

    }
    
    private func getEveryPokemonOnListNextPage(pokemonList: PokemonListDto) {
        let publishers: [AnyPublisher<PokemonDto, Error>] = pokemonList.results.map { pokemon in
            network.getPokemonPublisher(url: pokemon.url)
        }
        
        let publisherMerged = Publishers.MergeMany(publishers)
        
        publisherMerged
            .collect()
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { pokemonsDto in
                DispatchQueue.main.async {
                    let newPokemons = pokemonsDto.map { $0.toPresentation }.sorted { $0.id < $1.id }
                    self.pokemons.append(contentsOf: newPokemons)
                    self.pokemonsDownloaded.append(contentsOf: newPokemons)
                }

            }
            .store(in: &subscribers)

    }
    
    private func getPokemonsWithPages(offset: Int) {
        network.getPokemonsListPublisher(offset: offset)
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { pokemonList in
                self.getEveryPokemonOnListNextPage(pokemonList: pokemonList)
            }
            .store(in: &self.subscribers)
    }
    
    func shouldCallNextPageOfPokemons(pokemon: Pokemon) {
        if pokemons.last?.id == pokemon.id {
            currentOffset += 20
            getPokemonsWithPages(offset: currentOffset)
        }
    }
    
    func searchPokemons(search: String) {
        if search == "" {
            DispatchQueue.main.async {
                self.pokemons = self.pokemonsDownloaded
            }
  
        } else {
            let pokemonsFiltered = pokemonsDownloaded.filter { $0.name.contains(search.lowercased()) }
            pokemons = pokemonsFiltered
            
            if pokemons.count == 0 {
                searchPokemonsFromApy(search: search)
            }
        }
    }
    
    private func searchPokemonsFromApy(search: String) {
        network.searchPokemon(search: search)
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { pokemon in
                DispatchQueue.main.async {
                    guard let pokemon else { return }
                    self.pokemons.append(pokemon.toPresentation)
                }
            }
            .store(in: &self.subscribers)
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
        
        func getPokemons() {
            target.getPokemons()
        }
        
        func getPokemonsWithPages(offset: Int) {
            target.getPokemonsWithPages(offset: offset)
        }
    }
}
#endif
