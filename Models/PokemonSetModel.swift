import Foundation

struct PokemonSetModel: Codable, Identifiable, Equatable {
    static func == (lhs: PokemonSetModel, rhs: PokemonSetModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let name: String?
    let series: String?
    let printedTotal: Int?
    let total: Int?
    let legalities: Legalities?
    let ptcgoCode: String?
    let releaseDate: String?
    let updatedAt: String?
    let images: SetImages?
    
    struct Legalities: Codable, Hashable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    struct SetImages: Codable, Hashable {
        let symbol: String?
        let logo: String?
    }
}

extension PokemonSetModel {
    static let sampleSet = PokemonSetModel(
        id: "swsh4",
        name: "Vivid Voltage",
        series: "Sword & Shield",
        printedTotal: 185,
        total: 203,
        legalities: Legalities(
            unlimited: "Legal",
            standard: "Legal",
            expanded: "Legal"
        ),
        ptcgoCode: "VIV",
        releaseDate: "2020/11/13",
        updatedAt: "2020/11/13 16:20:00",
        images: SetImages(
            symbol: "https://images.pokemontcg.io/swsh4/symbol.png",
            logo: "https://images.pokemontcg.io/swsh4/logo.png"
        )
    )
} 