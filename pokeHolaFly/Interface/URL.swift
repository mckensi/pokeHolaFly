//
//  URL.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import Foundation

let prod = URL(string: "https://pokeapi.co/api/v2/")!
#if DEBUG
let dev = URL(string: "https://pokeapi.co/api/v2/")!
#endif

#if RELEASE
let api = prod
#else
let api = dev // Aquí iría DESA si hubiera un DESA o lo que toque
#endif

extension URL {
    static func getPokemons(limit: Int = 20, offset: Int = 0) -> URL {
        api.appending(path: "pokemon")
            .appending(
                queryItems: [
                    URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "offset", value: "\(offset)")
                ]
            )
        
    }
    
    static func getPokemon(url: String) -> URL {
          URL(string: url) ?? URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!
    }
}

