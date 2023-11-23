//
//  DataTest.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import Foundation
import Combine

extension Pokemon {
    static let test = Pokemon(
        id: 1,
        abilities: [Ability(name: "overgrow", slot: 1)],
        height: 7,
        moves: [
            Move(name: "raszor-wind", url: URL(string: "https://pokeapi.co/api/v2/move/144/")),
            Move(name: "razor-wind", url: URL(string: "https://pokeapi.co/api/v2/move/144/")),
            Move(name: "razwor-wind", url: URL(string: "https://pokeapi.co/api/v2/move/144/")),
            Move(name: "razwor-wisnd", url: URL(string: "https://pokeapi.co/api/v2/move/144/")),
            Move(name: "razwor-wisnd", url: URL(string: "https://pokeapi.co/api/v2/move/144/"))
        ],
        name: "bulbasaur",
        sprites: Sprites(
            frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"),
            backDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png"),
            other: Other(
                dreamWorld: DreamWorld(frontDefault: URL(string:  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg")),
                officialArtwork: OfficialArtwork(frontDefault: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"))
            )
        ),
        stats: [Stat(baseStat: 45, effort: 0, name: "hp"), Stat(baseStat: 49, effort: 0, name: "attack"),  Stat(baseStat: 49, effort: 0, name: "defense")],
        types: [TypeElement(slot: 1, name: "grass"), TypeElement(slot: 2, name: "poison")],
        weight: 69
    )
}

extension PokemonsVM {
    static let test = PokemonsVM(network: DataTest())
}

struct DataTest: DataInteractor {
    func searchPokemon(search: String) -> AnyPublisher<PokemonDto?, Error> {
        let pokemon: PokemonDto? = nil
        
        // Simulamos una solicitud asincrónica
        return Future<PokemonDto?, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                promise(.success(pokemon))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getPokemonsListPublisher(offset: Int) -> AnyPublisher<PokemonListDto, Error> {
        let url = Bundle.main.url(forResource: "pokemonListTest", withExtension: "json")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonListDto.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getPokemonPublisher(url: String) -> AnyPublisher<PokemonDto, Error> {
        if url == "https://pokeapi.co/api/v2/pokemon/25/" {
            let url = Bundle.main.url(forResource: "pikachu", withExtension: "json")!
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: PokemonDto.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } else {
            let url = Bundle.main.url(forResource: "caterpie", withExtension: "json")!
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: PokemonDto.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
    }

    func getMoveDetail(urls: [URL?]) -> [AnyPublisher<MoveDetailDto, Error>] {
        let moveDetailDto = MoveDetailDto(id: 1, effectEntries: [], flavorTextEntries: [], name: "Hit", names: [], pp: 0, priority: 1, type: ContestType(name: "name", url: ""))
        let first = Future<MoveDetailDto, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                promise(.success(moveDetailDto))
            }
        }
        .eraseToAnyPublisher()
        
        let second = Future<MoveDetailDto, Error> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                promise(.success(moveDetailDto))
            }
        }
        .eraseToAnyPublisher()
        
        return [first, second]
    }
}

extension PokemonDetailVM {
    static let test = PokemonDetailVM(network: DataTest(), pokemon: .test)
}

extension MoveDetail {
    static let arrayTest: [MoveDetail] = [
        MoveDetail(id: 1, name: "transform", description: "User copies the target's species, weight, type, ability, calculated stats (except HP), and moves.  Copied moves will all have 5 PP remaining.  IVs are copied for the purposes of hidden power, but stats are not recalculated.\n\nchoice band, choice scarf, and choice specs stay in effect, and the user must select a new move.\n\nThis move cannot be copied by mirror move, nor forced by encore."
                      ),
        MoveDetail(id: 2, name: "transform", description: "User copies the target's species, weight, type, ability.")
    ]
}
