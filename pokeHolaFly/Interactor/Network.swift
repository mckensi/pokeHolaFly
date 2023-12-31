//
//  Network.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

protocol DataInteractor {
    func getPokemonsList(offset: Int) async throws -> [Pokemon]
    func getPokemon(url: String) async throws -> PokemonDto
    func searchPokemon(search: String)  async throws -> Pokemon?
    func getMoveDetail(urls: [URL?]) async throws -> [MoveDetail]
}

public struct Network: DataInteractor {
    
    func getJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }

    func getPokemonsList(offset: Int) async throws -> [Pokemon] {

        let pokemonList = try await getJSON(request: .get(url: .getPokemons(offset: offset)), type: PokemonListDto.self)
        
        return try await withThrowingTaskGroup(of: PokemonDto.self, returning: [Pokemon].self) { group in
            var result: [Pokemon] = []
            for pokemon in pokemonList.results {
                group.addTask {
                    try await getPokemon(url: pokemon.url)
                }
            }
            
            for try await pokemon in group {
                result.append(pokemon.toPresentation)
            }
            
            return result
        }
    }
    
    func getPokemonsListIgnorePokemosErrors() async throws -> [Pokemon] {

        let pokemonList = try await getJSON(request: .get(url: .getPokemons()), type: PokemonListDto.self)
        
        return await withTaskGroup(of: PokemonDto?.self, returning: [Pokemon].self) { group in
            var result: [Pokemon] = []
            for pokemon in pokemonList.results {
                group.addTask {
                    do {
                        return try await getPokemon(url: pokemon.url)
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
            
            for await pokemon in group.compactMap({ $0 }) {
                result.append(pokemon.toPresentation)
            }
            
            return result
        }
    }
     
    func getPokemon(url: String) async throws -> PokemonDto {
        try await getJSON(request: .get(url: .getPokemon(url: url)), type: PokemonDto.self)
    }
    
    func searchPokemon(search: String) async throws -> Pokemon? {
        try await getJSON(request: .get(url: .searchPokemon(search: search)), type: PokemonDto?.self)?.toPresentation
    }
    
    func getMoveDetail(urls: [URL?]) async throws -> [MoveDetail] {
        return await withTaskGroup(of: MoveDetailDto?.self, returning: [MoveDetail].self) { group in
            var result: [MoveDetail] = []
            for url in urls {
                group.addTask {
                    do {
                        return try await getJSON(request: .get(url: .getMoveDetail(url: url)), type: MoveDetailDto.self)
                    } catch {
                        print(error)
                        return nil
                    }
                }
            }
            
            for await move in group.compactMap({ $0 }) {
                result.append(move.toPresentation)
            }
            
            return result
        }
    }
}
