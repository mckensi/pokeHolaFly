import Foundation

// MARK: - PokemonDto
struct PokemonDto: Codable {
    let id: Int
    let abilities: [AbilityDto]
    let height: Int
    let moves: [MoveDto]
    let name: String
    let sprites: SpritesDto
    let stats: [StatDto]
    let types: [TypeElementDto]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case id
        case abilities
        case height
        case moves, name
        case sprites, stats, types, weight
    }
}

// MARK: - AbilityDto
struct AbilityDto: Codable {
    let ability: AbilityContentDto
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - AbilityContentDto
struct AbilityContentDto: Codable {
    let name: String
    let url: String
}

// MARK: - MoveContentDto
struct MoveContentDto: Codable {
    let name: String
    let url: String
}

// MARK: - MoveDto
struct MoveDto: Codable {
    let move: MoveContentDto

    enum CodingKeys: String, CodingKey {
        case move
    }
}


// MARK: - Sprites
struct SpritesDto: Codable {
    let backDefault: String
    let backShiny: String
    let frontDefault: String
    let frontShiny: String

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - StatContentDto
struct StatContentDto: Codable {
    let name: String
    let url: String
}

// MARK: - Stat
struct StatDto: Codable {
    let baseStat, effort: Int
    let stat: StatContentDto

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

// MARK: - AbilityContentDto
struct ContentTypeElementDto: Codable {
    let name: String
}

// MARK: - TypeElement
struct TypeElementDto: Codable {
    let slot: Int
    let type: ContentTypeElementDto
}

extension PokemonDto {
    var toPresentation: Pokemon {
        Pokemon(
            id: id,
            abilities: abilities.map { Ability(name: $0.ability.name, slot: $0.slot)},
            height: height,
            moves: moves.map { Move(name: $0.move.name) },
            name: name,
            sprites: Sprites(frontDefault: URL(string: sprites.frontDefault), backDefault: URL(string: sprites.backDefault)),
            stats: stats.map { Stat(baseStat: $0.baseStat, effort: $0.effort, name: $0.stat.name)},
            types: types.map { TypeElement(slot: $0.slot, name: $0.type.name)},
            weight: weight
        )
    }
}
