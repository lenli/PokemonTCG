import Foundation

struct PokemonCardResponse: Codable {
    let data: [PokemonModel]
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int
}

struct PokemonCardSingleResponse: Codable {
    let data: PokemonModel
} 