import Foundation

struct PokemonSetResponse: Codable {
    let data: [PokemonSetModel]
    let page: Int
    let pageSize: Int
    let count: Int
    let totalCount: Int
}

struct PokemonSetSingleResponse: Codable {
    let data: PokemonSetModel
} 