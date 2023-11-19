//
//  MoveDetailDto.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import Foundation

// MARK: - MoveDetailDto
struct MoveDetailDto: Codable {
    let id: Int
    let effectEntries: [EffectEntry]
    let flavorTextEntries: [FlavorTextEntry]
    let name: String
    let names: [Name]
    let pp, priority: Int
    let type: ContestType

    enum CodingKeys: String, CodingKey {
        case id
        case effectEntries = "effect_entries"
        case flavorTextEntries = "flavor_text_entries"
        case name, names
        case pp, priority
        case type
    }
}

// MARK: - ContestType
struct ContestType: Codable {
    let name: String
    let url: String
}

// MARK: - EffectEntry
struct EffectEntry: Codable {
    let effect: String
    let language: ContestType
    let shortEffect: String

    enum CodingKeys: String, CodingKey {
        case effect, language
        case shortEffect = "short_effect"
    }
}

// MARK: - FlavorTextEntry
struct FlavorTextEntry: Codable {
    let flavorText: String
    let language, versionGroup: ContestType

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
        case versionGroup = "version_group"
    }
}

// MARK: - Name
struct Name: Codable {
    let language: ContestType
    let name: String
}

extension MoveDetailDto {
    var toPresentation: MoveDetail {
        MoveDetail(id: self.id, name: self.name, description: self.effectEntries.first?.effect ?? "")
    }
}
