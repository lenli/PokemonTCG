import Foundation

struct PokemonModel: Codable, Identifiable, Equatable {
    static func == (lhs: PokemonModel, rhs: PokemonModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: String
    let name: String
    let supertype: String?
    let subtypes: [String]?
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let evolvesTo: [String]?
    let rules: [String]?
    let abilities: [Ability]?
    let attacks: [Attack]?
    let weaknesses: [Weakness]?
    let resistances: [Resistance]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let set: SetInfo?
    let number: String?
    let artist: String?
    let rarity: String?
    let flavorText: String?
    let nationalPokedexNumbers: [Int]?
    let legalities: Legalities?
    let images: Images?
    let tcgplayer: TCGPlayer?
    let cardmarket: CardMarket?
    
    struct Ability: Codable, Hashable {
        let name: String?
        let text: String?
        let type: String?
    }
    
    struct Attack: Codable, Hashable {
        let name: String?
        let cost: [String]?
        let convertedEnergyCost: Int?
        let damage: String?
        let text: String?
    }
    
    struct Weakness: Codable, Hashable {
        let type: String
        let value: String
    }
    
    struct Resistance: Codable, Hashable {
        let type: String
        let value: String
    }
    
    struct SetInfo: Codable, Hashable {
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
    }
    
    struct SetImages: Codable, Hashable {
        let symbol: String?
        let logo: String?
    }
    
    struct Legalities: Codable, Hashable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    struct Images: Codable, Hashable {
        let small: String?
        let large: String?
    }
    
    struct TCGPlayer: Codable, Hashable {
        let url: String?
        let updatedAt: String?
        let prices: TCGPlayerPrices?
    }
    
    struct TCGPlayerPrices: Codable, Hashable {
        let low: Double?
        let mid: Double?
        let high: Double?
        let market: Double?
        let directLow: Double?
    }
    
    struct CardMarket: Codable, Hashable {
        let url: String?
        let updatedAt: String?
        let prices: CardMarketPrices?
    }
    
    struct CardMarketPrices: Codable, Hashable {
        let averageSellPrice: Double?
        let lowPrice: Double?
        let trendPrice: Double?
        let germanProLow: Double?
        let suggestedPrice: Double?
        let reverseHoloSell: Double?
        let reverseHoloLow: Double?
        let reverseHoloTrend: Double?
        let lowPriceExPlus: Double?
        let avg1: Double?
        let avg7: Double?
        let avg30: Double?
        let reverseHoloAvg1: Double?
        let reverseHoloAvg7: Double?
        let reverseHoloAvg30: Double?
    }
}

extension PokemonModel {
    static let samplePokemon = PokemonModel(
        id: "xy1-1",
        name: "Venusaur-EX",
        supertype: "Pokémon",
        subtypes: ["Basic", "EX"],
        hp: "180",
        types: ["Grass"],
        evolvesFrom: nil,
        evolvesTo: nil,
        rules: nil,
        abilities: nil,
        attacks: [
            Attack(
                name: "Poison Powder",
                cost: ["Grass", "Grass", "Colorless"],
                convertedEnergyCost: 3,
                damage: "60",
                text: "Your opponent's Active Pokémon is now Poisoned."
            ),
            Attack(
                name: "Solar Beam",
                cost: ["Grass", "Grass", "Grass", "Colorless"],
                convertedEnergyCost: 4,
                damage: "120",
                text: nil
            )
        ],
        weaknesses: [
            Weakness(type: "Fire", value: "×2")
        ],
        resistances: nil,
        retreatCost: ["Colorless", "Colorless", "Colorless", "Colorless"],
        convertedRetreatCost: 4,
        set: SetInfo(
            id: "xy1",
            name: "XY",
            series: "XY",
            printedTotal: 146,
            total: 146,
            legalities: Legalities(unlimited: "Legal", standard: "Legal", expanded: "Legal"),
            ptcgoCode: "XY",
            releaseDate: "2014/02/05",
            updatedAt: "2022/10/10 15:12:00",
            images: SetImages(
                symbol: "https://images.pokemontcg.io/xy1/symbol.png",
                logo: "https://images.pokemontcg.io/xy1/logo.png"
            )
        ),
        number: "1",
        artist: "Eske Yoshinob",
        rarity: "Rare Holo EX",
        flavorText: nil,
        nationalPokedexNumbers: [3],
        legalities: Legalities(unlimited: "Legal", standard: "Legal", expanded: "Legal"),
        images: Images(
            small: "https://images.pokemontcg.io/xy1/1.png",
            large: "https://images.pokemontcg.io/xy1/1_hires.png"
        ),
        tcgplayer: nil,
        cardmarket: nil
    )
} 