//
//  Color.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import Foundation
import SwiftUI

func getColorBackground(type: TypeElement?) -> Color {
    guard let type else {
        return .pokeGround
    }
    switch type.name {
    case "normal":
        return .pokeGround
    case "fighting":
        return .gray
    case "flying":
        return .pokeSilver
    case "poison":
        return .pokePurple
    case "ground":
        return .pokeGround
    case "rock":
        return .pokeRock
    case "bug":
        return .pokegreen
    case "ghost":
        return .pokeSilver
    case "steel":
        return .pokeSilver
    case "fire":
        return .pokeOrange
    case "water":
        return .pokeblue
    case "grass":
        return .pokegreen
    case "electric":
        return .yellow
    case "psychic":
        return .pokeSilver
    case "ice":
        return .pokeSilver
    case "dragon":
        return .pokeSilver
    case "dark":
        return .pokeSilver
    case "fairy":
        return .pokeSilver
    case "shadow":
        return .pokeSilver
    default:
        return .pokeSilver
    }
}

func getColorBackgroundType(type: TypeElement?) -> Color {
    guard let type else {
        return .pokeGround
    }

    switch type.name {
    case "normal":
        return .typeGround
    case "fighting":
        return .gray
    case "flying":
        return .typeSilver
    case "poison":
        return .typePurple
    case "ground":
        return .typeGround
    case "rock":
        return .typeRock
    case "bug":
        return .typeGreen
    case "ghost":
        return .typeSilver
    case "steel":
        return .typeSilver
    case "fire":
        return .typeOrange
    case "water":
        return .typeblue
    case "grass":
        return .typeGreen
    case "electric":
        return .yellow
    case "psychic":
        return .typeSilver
    case "ice":
        return .typeSilver
    case "dragon":
        return .typeSilver
    case "dark":
        return .typeSilver
    case "fairy":
        return .typeSilver
    case "shadow":
        return .typeSilver
    default:
        return .typeSilver
    }
}
