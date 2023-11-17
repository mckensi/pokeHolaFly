//
//  Pokemon.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import Foundation
import SwiftUI

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let abilities: [Ability]
    let height: Int
    let moves: [Move]
    let name: String
    let sprites: Sprites
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
}

struct Ability: Identifiable, Hashable {
    var id: Self { self }
    let name: String
    let slot: Int
}

struct Move: Identifiable, Hashable {
    var id: Self { self }
    let name: String
}

struct Sprites: Identifiable, Hashable {
    var id: Self { self }
    let frontDefault: URL?
    let backDefault: URL?
}

struct Stat: Identifiable, Hashable {
    var id: Self { self }
    let baseStat, effort: Int
    let name: String
}

struct TypeElement: Identifiable, Hashable {
    var id: Self { self }
    let slot: Int
    let name: String
}
