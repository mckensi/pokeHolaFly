//
//  DataTest.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import Foundation

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
    func searchPokemon(search: String) async throws -> Pokemon? {
        return .test
    }
    
    func getPokemonsList(offset: Int) async throws -> [Pokemon] {
        let pokemonList = try loadTestData()
        
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
    
    func getPokemon(url: String) async throws -> PokemonDto {
        if url == "https://pokeapi.co/api/v2/pokemon/25/" {
            let url = Bundle.main.url(forResource: "pikachu", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(PokemonDto.self, from: data)
        } else {
            let url = Bundle.main.url(forResource: "caterpie", withExtension: "json")!
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(PokemonDto.self, from: data)
        }
    }

    func loadTestData() throws -> PokemonListDto {
        let url = Bundle.main.url(forResource: "pokemonListTest", withExtension: "json")!
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(PokemonListDto.self, from: data)
    }
    
    func getMoveDetail(urls: [URL?]) async throws -> [MoveDetail] {
        let url = Bundle.main.url(forResource: "caterpie-moves", withExtension: "json")!
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([MoveDetailDto].self, from: data).map(\.toPresentation)
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
