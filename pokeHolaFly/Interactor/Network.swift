//
//  Network.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI
import Combine

protocol DataInteractor {
    func getPokemonsListPublisher(offset: Int) -> AnyPublisher<PokemonListDto, Error>
    func getPokemonPublisher(url: String) -> AnyPublisher<PokemonDto, Error>
    func searchPokemon(search: String) -> AnyPublisher<PokemonDto?, Error>
    func getMoveDetail(urls: [URL?]) -> [AnyPublisher<MoveDetailDto, Error>]
}

public struct Network: DataInteractor {
    
    var subscribers = Set<AnyCancellable>()
    
    func getJSON<JSON>(request: URLRequest, type: JSON.Type) -> AnyPublisher<JSON, Error> where JSON: Codable {
        return URLSession.shared.getData(for: request)
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func getPokemonsListPublisher(offset: Int) -> AnyPublisher<PokemonListDto, Error> {
        return getJSON(request: .get(url: .getPokemons(offset: offset)), type: PokemonListDto.self)
    }
    
    func getPokemonPublisher(url: String) -> AnyPublisher<PokemonDto, Error> {
        return getJSON(request: .get(url: .getPokemon(url: url)), type: PokemonDto.self).eraseToAnyPublisher()
    }
    
//    func searchPokemon(search: String) async throws -> Pokemon? {
//        try await getJSON(request: .get(url: .searchPokemon(search: search)), type: PokemonDto?.self)?.toPresentation
//    }
    
    func searchPokemon(search: String) -> AnyPublisher<PokemonDto?, Error> {
        return getJSON(request: .get(url: .searchPokemon(search: search)), type: PokemonDto?.self).eraseToAnyPublisher()
    }
    
//    func getMoveDetail(urls: [URL?]) async throws -> [MoveDetail] {
//        return await withTaskGroup(of: MoveDetailDto?.self, returning: [MoveDetail].self) { group in
//            var result: [MoveDetail] = []
//            for url in urls {
//                group.addTask {
//                    do {
//                        return try await getJSON(request: .get(url: .getMoveDetail(url: url)), type: MoveDetailDto.self)
//                    } catch {
//                        print(error)
//                        return nil
//                    }
//                }
//            }
//            
//            for await move in group.compactMap({ $0 }) {
//                result.append(move.toPresentation)
//            }
//            
//            return result
//        }
//    }
    
    func getMoveDetail(urls: [URL?]) -> [AnyPublisher<MoveDetailDto, Error>] {
        let publishers: [AnyPublisher<MoveDetailDto, Error>] = urls.map { url in
            getJSON(request: .get(url: url!), type: MoveDetailDto.self)
        }
        return publishers
    }
}
