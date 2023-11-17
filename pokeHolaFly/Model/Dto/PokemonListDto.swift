//
//  PokemonList.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import Foundation

// MARK: - PokemonList
struct PokemonListDto: Codable {
    let count: Int
    let next: String
    let results: [ResultDto]
}

// MARK: - Result
struct ResultDto: Codable {
    let name: String
    let url: String
}
