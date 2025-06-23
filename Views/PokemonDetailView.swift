import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject private var viewModel: PokemonViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: PokemonViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.grayscale1
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with large card image
                    VStack(spacing: 16) {
                        AsyncImage(url: viewModel.largeImageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .grayscale1.opacity(0.8), radius: 12, x: 0, y: 6)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.grayscale4)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 48))
                                            .foregroundColor(.grayscale7)
                                        Text("Loading...")
                                            .font(.caption)
                                            .foregroundColor(.grayscale7)
                                    }
                                )
                        }
                        .frame(maxWidth: 280, maxHeight: 390)
                        
                        VStack(spacing: 8) {
                            if let setName = viewModel.displaySetName {
                                Text(setName)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primaryLime1)
                            }
                            
                            Text(viewModel.displayName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.grayscale10)
                                .multilineTextAlignment(.center)

                            if let supertype = viewModel.supertype {
                                Text(supertype)
                                    .font(.title3)
                                    .foregroundColor(.grayscale7)
                            }
                        }
                    }
                    .padding(.top)

                    // Card Details Section
                    ModernSection(title: "Card Details") {
                        VStack(alignment: .leading, spacing: 12) {
                            if let hp = viewModel.hp {
                                InfoRow(label: "HP", value: hp)
                            }
                            
                            if let cardNumber = viewModel.cardNumber {
                                InfoRow(label: "Card Number", value: cardNumber)
                            }
                            
                            if let rarity = viewModel.rarity {
                                InfoRow(label: "Rarity", value: rarity)
                            }
                            
                            InfoRow(label: "Artist", value: viewModel.toPokemonModel().artist!)
                            
                            if viewModel.hasTypes {
                                HStack {
                                    Text("Types")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.grayscale10)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 6) {
                                        ForEach(viewModel.types, id: \.self) { type in
                                            TypeBadge(type: type, viewModel: viewModel)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Attacks Section
                    if viewModel.hasAttacks {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Attacks")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.grayscale10)

                            VStack(spacing: 12) {
                                ForEach(viewModel.attacks, id: \.self) { attack in
                                    ModernAttackView(attack: attack, viewModel: viewModel)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.grayscale4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.grayscale7.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }

                    // Set Information
                    if viewModel.hasSetInfo {
                        ModernSection(title: "Set Information") {
                            VStack(alignment: .leading, spacing: 12) {
                                if let series = viewModel.setSeries {
                                    InfoRow(label: "Series", value: series)
                                }
                                
                                if let total = viewModel.setTotal {
                                    InfoRow(label: "Total Cards", value: "\(total)")
                                }
                                
                                if let releaseDate = viewModel.setReleaseDate {
                                    InfoRow(label: "Release Date", value: releaseDate)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.grayscale1, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            do {
                viewModel.pageNumber += 1
                let pokemonCardResponse = try await PokemonTCGService.shared.fetchCards(
                    page: viewModel.pageNumber,
                    pageSize: 1,
                    name: viewModel.name
                )
                if let fetchedPokemon = pokemonCardResponse.data.first {
                    viewModel.configure(pokemon: fetchedPokemon)
                }
            } catch {
                print("Failed to fetch additional data: \(error)")
            }
        }
    }
}

// MARK: - Supporting Views

struct ModernSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.grayscale10)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.grayscale4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.grayscale7.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.grayscale10)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.grayscale9)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct TypeBadge: View {
    let type: String
    let viewModel: PokemonViewModel

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.iconForType(type))
                .font(.caption2)
                .foregroundColor(viewModel.colorForType(type))
            Text(type)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(viewModel.colorForType(type))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Color.grayscale3)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.grayscale6, lineWidth: 1)
        )
        .clipShape(Capsule())
    }
}

struct ModernAttackView: View {
    let attack: PokemonModel.Attack
    let viewModel: PokemonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                // Flexible container that wraps if needed
                HStack(alignment: .center, spacing: 8) {
                    Text(attack.name ?? "Unknown Attack")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryLime1)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    EnergyCostView(cost: attack.cost, viewModel: viewModel)
                }
                .layoutPriority(1) // Give priority to the name + cost section

                Spacer()

                if let damage = attack.damage, !damage.isEmpty {
                    Text(damage)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryLime1)
                }
            }

            if let text = attack.text, !text.isEmpty {
                Text(text)
                    .font(.body)
                    .foregroundColor(.grayscale9)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayscale4.opacity(0.5))
        )
    }
}

struct EnergyCostView: View {
    let cost: [String]?
    let viewModel: PokemonViewModel
    
    var body: some View {
        if let cost = cost, !cost.isEmpty {
            HStack(spacing: 4) {
                ForEach(cost, id: \.self) { energy in
                    EnergyIcon(energy: energy, viewModel: viewModel)
                }
            }
        }
    }
}

struct EnergyIcon: View {
    let energy: String
    let viewModel: PokemonViewModel
    
    var body: some View {
        Group {
            if let textSymbol = textSymbolForEnergyType(energy) {
                Text(textSymbol)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.grayscale10)
            } else {
                Image(systemName: viewModel.iconForType(energy))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(foregroundColorForEnergy(energy))
            }
        }
        .frame(width: 20, height: 20)
        .background(viewModel.colorForType(energy))
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.grayscale1.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    private func textSymbolForEnergyType(_ energy: String) -> String? {
        switch energy.lowercased() {
        case "fire": return "🔥"
        case "water": return "💧"
        case "grass": return "🌿"
        case "lightning", "electric": return "⚡"
        case "psychic": return "🔮"
        case "fighting": return "👊"
        case "darkness", "dark": return "🌙"
        case "metal", "steel": return "⚙️"
        case "fairy": return "✨"
        case "dragon": return "🐲"
        case "colorless", "normal": return nil  // Use SF Symbol instead
        case "poison": return "☠️"
        default: return nil
        }
    }
    
    private func foregroundColorForEnergy(_ energy: String) -> Color {
        switch energy.lowercased() {
        case "colorless", "normal": return .white
        default: return .grayscale10
        }
    }
}

#Preview {
    NavigationView {
        PokemonDetailView(viewModel: PokemonViewModel(pokemon: PokemonModel.samplePokemon))
    }
    .preferredColorScheme(.dark)
}

#Preview("Energy Icons") {
    EnergyIconPreview()
        .preferredColorScheme(.dark)
}

struct EnergyIconPreview: View {
    let energyTypes = [
        "fire", "water", "grass", "lightning", "electric", 
        "psychic", "fighting", "darkness", "dark", "metal", 
        "steel", "fairy", "dragon", "colorless", "normal",
        "ground", "rock", "bug", "ghost", "ice", "flying", "poison"
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(energyTypes, id: \.self) { energy in
                    VStack(spacing: 8) {
                        EnergyIcon(energy: energy, viewModel: PokemonViewModel(pokemon: PokemonModel.samplePokemon))
                        Text(energy.capitalized)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .navigationTitle("Energy Icons")
    }
} 
