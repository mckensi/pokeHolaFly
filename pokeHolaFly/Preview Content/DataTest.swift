//
//  DataTest.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import Foundation

import Foundation

extension Pokemon {
    static let test = Pokemon(
        id: 1,
        abilities: [Ability(name: "overgrow", slot: 1)],
        height: 7,
        moves: [
            Move(name: "raszor-wind"),
            Move(name: "razor-wind"),
            Move(name: "razwor-wind"),
            Move(name: "razwor-wisnd"),
            Move(name: "razwor-wisnd")
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
        if offset != 0 {
            return []
        }
        return try loadTestData()
    }
    
    func getPokemon(url: String) async throws -> PokemonDto {
        return PokemonDto(
            id: 1,
            abilities: [],
            height: 1,
            moves: [],
            name: "bulbasour",
            sprites: SpritesDto(
                backDefault: "",
                backShiny: "",
                frontDefault: "",
                frontShiny: "", 
                other: OtherDto(
                    dreamWorld: DreamWorldDto(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg"
                    ),
                    officialArtWork: OfficialArtWorkDto(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
                )
            ),
            stats: [],
            types: [],
            weight: 2
        )
    }
    
    let url = Bundle.main.url(forResource: "pokemonList", withExtension: "json")!
    
    func loadTestData() throws -> [Pokemon] {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([PokemonDto].self, from: data).map(\.toPresentation)
    }

}
