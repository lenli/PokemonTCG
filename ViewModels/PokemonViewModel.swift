// PokemonViewModel.swift
// Copyright (c) 2024 Pokemon TCG App

import Foundation
import SwiftUI

@MainActor
class PokemonViewModel: ObservableObject {
    private(set) var id: String = ""
    private(set) var name: String = ""
    private(set) var hp: String?
    private(set) var number: String?
    private(set) var rarity: String?
    private(set) var artist: String?
    private(set) var supertype: String?
    private(set) var types: [String] = []
    private(set) var attacks: [PokemonModel.Attack] = []
    private(set) var smallImageUrl: String?
    private(set) var largeImageUrl: String?
    private(set) var setName: String?
    private(set) var setSeries: String?
    private(set) var setTotal: Int?
    private(set) var setReleaseDate: String?
    private(set) var marketPrice: Double?
    
    @Published var pageNumber = 1
    
    var shareUrl: String? {
        return "https://pokemontcg.io/card/\(id)"
    }
    
    var displayName: String {
        name
    }
    
    var cardNumber: String? {
        guard let number = number else { return nil }
        return "#\(number)"
    }
    
    var displaySetName: String? {
        setName?.uppercased()
    }
    
    var cardIdentifier: String {
        if let cardNum = cardNumber, let setName = setName {
            return "\(cardNum) • \(setName)"
        } else if let cardNum = cardNumber {
            return cardNum
        } else if let setName = setName {
            return setName
        }
        return name
    }
    
    var formattedMarketPrice: String? {
        guard let price = marketPrice else { return nil }
        return "$\(Int(price))"
    }
    
    var languagesString: String {
        types.joined(separator: ", ")
    }
    
    var smallImageURL: URL? {
        guard let urlString = smallImageUrl else { return nil }
        return URL(string: urlString)
    }
    
    var largeImageURL: URL? {
        guard let urlString = largeImageUrl else { return nil }
        return URL(string: urlString)
    }
    
    var hasTypes: Bool {
        !types.isEmpty
    }
    
    var hasAttacks: Bool {
        !attacks.isEmpty
    }
    
    var hasSetInfo: Bool {
        setName != nil
    }
    
    var hasMarketPrice: Bool {
        marketPrice != nil
    }
    
    var primaryType: String? {
        types.first
    }
    
    var attackCount: Int {
        attacks.count
    }
    
    // MARK: - State
    
    @Published var isFavorited = false
    @Published var isLoading = false
    
    // MARK: - Constructors
    
    init() {}
    
    init(pokemon: PokemonModel) {
        configure(pokemon: pokemon)
    }
    
    // MARK: - Configure
    
    func configure(pokemon: PokemonModel) {
        id = pokemon.id
        name = pokemon.name
        hp = pokemon.hp
        number = pokemon.number
        rarity = pokemon.rarity
        artist = pokemon.artist
        supertype = pokemon.supertype
        types = pokemon.types ?? []
        attacks = pokemon.attacks ?? []
        smallImageUrl = pokemon.images?.small
        largeImageUrl = pokemon.images?.large
        setName = pokemon.set?.name
        setSeries = pokemon.set?.series
        setTotal = pokemon.set?.total
        setReleaseDate = pokemon.set?.releaseDate
        marketPrice = pokemon.tcgplayer?.prices?.market
        objectWillChange.send()
    }
    
    // MARK: - Business Logic
    
    func toggleFavorite() {
        isFavorited.toggle()
        objectWillChange.send()
    }
    
    // MARK: - Type/Energy Helpers
    
    func colorForType(_ type: String) -> Color {
        switch type.lowercased() {
        case "fire": return Color(red: 0.8, green: 0.2, blue: 0.1)
        case "water": return Color(red: 0.1, green: 0.6, blue: 0.8)
        case "grass": return Color(red: 0.2, green: 0.7, blue: 0.1)
        case "lightning", "electric": return Color(red: 0.9, green: 0.7, blue: 0.0)
        case "psychic": return Color(red: 0.4, green: 0.2, blue: 0.8)
        case "fighting": return Color(red: 0.8, green: 0.4, blue: 0.1)
        case "darkness", "dark": return .grayscale5
        case "metal", "steel": return .grayscale6
        case "fairy": return Color(red: 0.8, green: 0.3, blue: 0.7)
        case "dragon": return Color(red: 0.3, green: 0.2, blue: 0.8)
        case "colorless", "normal": return .grayscale6
        case "ground": return Color(red: 0.6, green: 0.4, blue: 0.1)
        case "rock": return Color(red: 0.5, green: 0.4, blue: 0.2)
        case "bug": return Color(red: 0.4, green: 0.6, blue: 0.1)
        case "ghost": return Color(red: 0.4, green: 0.2, blue: 0.6)
        case "ice": return Color(red: 0.3, green: 0.7, blue: 0.9)
        case "flying": return Color(red: 0.4, green: 0.6, blue: 0.9)
        case "poison": return Color(red: 0.6, green: 0.2, blue: 0.6)
        default: return .grayscale6
        }
    }
    
    func iconForType(_ type: String) -> String {
        switch type.lowercased() {
        case "fire": return "flame.circle.fill"
        case "water": return "drop.circle.fill"
        case "grass": return "leaf.circle.fill"
        case "lightning", "electric": return "bolt.circle.fill"
        case "psychic": return "eye.circle.fill"
        case "fighting": return "fist.raised.circle.fill"
        case "darkness", "dark": return "moon.circle.fill"
        case "metal", "steel": return "gear.circle.fill"
        case "fairy": return "sparkle"
        case "dragon": return "hurricane.circle.fill"
        case "colorless", "normal": return "star.circle.fill"
        case "ground": return "mountain.2.circle.fill"
        case "rock": return "cube.fill"
        case "bug": return "ant.circle.fill"
        case "ghost": return "eye.trianglebadge.exclamationmark"
        case "ice": return "snowflake.circle.fill"
        case "flying": return "cloud.circle.fill"
        case "poison": return "drop.triangle.fill"
        default: return "circle.fill"
        }
    }
    
    // MARK: - Helpers
    
    func toPokemonModel() -> PokemonModel {
        return PokemonModel(
            id: id,
            name: name,
            supertype: supertype,
            subtypes: nil,
            hp: hp,
            types: types.isEmpty ? nil : types,
            evolvesFrom: nil,
            evolvesTo: nil,
            rules: nil,
            abilities: nil,
            attacks: attacks.isEmpty ? nil : attacks,
            weaknesses: nil,
            resistances: nil,
            retreatCost: nil,
            convertedRetreatCost: nil,
            set: hasSetInfo ? PokemonModel.SetInfo(
                id: "",
                name: setName,
                series: setSeries,
                printedTotal: nil,
                total: setTotal,
                legalities: nil,
                ptcgoCode: nil,
                releaseDate: setReleaseDate,
                updatedAt: nil,
                images: nil
            ) : nil,
            number: number,
            artist: artist,
            rarity: rarity,
            flavorText: nil,
            nationalPokedexNumbers: nil,
            legalities: nil,
            images: PokemonModel.Images(
                small: smallImageUrl,
                large: largeImageUrl
            ),
            tcgplayer: hasMarketPrice ? PokemonModel.TCGPlayer(
                url: nil,
                updatedAt: nil,
                prices: PokemonModel.TCGPlayerPrices(
                    low: nil,
                    mid: nil,
                    high: nil,
                    market: marketPrice,
                    directLow: nil
                )
            ) : nil,
            cardmarket: nil
        )
    }
}

// MARK: - Hashable

extension PokemonViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(number)
        hasher.combine(setName)
    }
    
    static func == (lhs: PokemonViewModel, rhs: PokemonViewModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.number == rhs.number
        && lhs.setName == rhs.setName
    }
} 
