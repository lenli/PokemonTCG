import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark Background
                Color.grayscale1
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    VStack {
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.grayscale7)
                                    .font(.system(size: 16))

                                TextField("Search Pokémon...", text: $viewModel.searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(.grayscale10)
                                    .onChange(of: viewModel.searchText) { _ in
                                        Task {
                                            await viewModel.searchCards()
                                        }
                                    }
                                    .onSubmit {
                                        Task {
                                            await viewModel.searchCards()
                                        }
                                    }
                                
                                if !viewModel.searchText.isEmpty {
                                    Button(action: {
                                        viewModel.searchText = ""
                                        Task {
                                            await viewModel.refresh()
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.grayscale7)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.grayscale3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.grayscale5, lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                    .background(Color.grayscale1)

                    if viewModel.isLoading && viewModel.pokemon.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                                .progressViewStyle(CircularProgressViewStyle(tint: .grayscale10))
                            Text("Loading Pokémon...")
                                .font(.subheadline)
                                .foregroundColor(.grayscale8)
                        }
                        Spacer()
                    } else if !viewModel.errorMessage.isNilOrEmpty {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 48))
                                .foregroundColor(.functionalError)
                            
                            Text("Something went wrong")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.grayscale10)
                            
                            Text(viewModel.errorMessage ?? "An unknown error occurred.")
                                .font(.body)
                                .foregroundColor(.grayscale8)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Try Again") {
                                Task {
                                    await viewModel.refresh()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding()
                        Spacer()
                    } else {
                        // Pokemon List
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.pokemon) { pokemon in
                                    let pokemonViewModel = PokemonViewModel(pokemon: pokemon)
                                    NavigationLink(destination: PokemonDetailView(viewModel: pokemonViewModel)) {
                                        PokemonCardView(viewModel: pokemonViewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .refreshable {
                            await viewModel.refresh()
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.grayscale1, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
    }
}

extension String? {
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}

#Preview {
    ContentView()
} 
