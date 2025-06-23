import SwiftUI

struct PokemonCardView: View {
    @ObservedObject var viewModel: PokemonViewModel

    var body: some View {
        HStack(spacing: 16) {
            // Pokemon Card Image
            AsyncImage(url: viewModel.smallImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.grayscale5)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.grayscale7)
                            .font(.system(size: 24))
                    )
            }
            .frame(width: 80, height: 112)
            .shadow(color: .grayscale1.opacity(0.5), radius: 4, x: 0, y: 2)

            // Pokemon Info
            VStack(alignment: .leading, spacing: 6) {
                // Set name in lime
                if let setName = viewModel.setName {
                    Text(setName.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primaryLime1)
                        .lineLimit(1)
                }
                
                // Pokemon name and number
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.displayName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.grayscale10)
                        .lineLimit(1)
                    
                    if let cardNumber = viewModel.cardNumber {
                        Text(cardNumber)
                            .font(.subheadline)
                            .foregroundColor(.grayscale8)
                    }
                }
                
                // Price
                if let price = viewModel.formattedMarketPrice {
                    Text(price)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.grayscale10)
                } else {
                    Text("Price N/A")
                        .font(.caption)
                        .foregroundColor(.grayscale8)
                }
                
                // Rarity badge
                if let rarity = viewModel.rarity {
                    Text(rarity)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(badgeColor(for: rarity))
                        .foregroundColor(.grayscale10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayscale7, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.grayscale7)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.grayscale3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.grayscale5, lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
    
    private func badgeColor(for rarity: String) -> Color {
        return .grayscale6  // Use same as lightning type
    }
}

#Preview {
    VStack {
        PokemonCardView(viewModel: PokemonViewModel(pokemon: PokemonModel.samplePokemon))
        PokemonCardView(viewModel: PokemonViewModel(pokemon: PokemonModel.samplePokemon))
    }
    .background(Color.grayscale1)
    .preferredColorScheme(.dark)
} 
