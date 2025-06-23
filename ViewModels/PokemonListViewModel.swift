// PokemonListViewModel.swift
// Copyright (c) 2024 Pokemon TCG App

import Foundation

@MainActor
class PokemonListViewModel: ObservableObject {
    private(set) var pokemon: [PokemonModel] = []
    private(set) var currentPage = 1
    private(set) var totalCount = 0
    private(set) var hasMorePages = true
    
    @Published var searchText = ""
    
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var isLoadingMore = false
    
    @Published var errorMessage: String?
    @Published var showError = false
    
    var isEmpty: Bool {
        pokemon.isEmpty
    }
    
    var isPerformingOperation: Bool {
        isLoading || isSearching || isLoadingMore
    }
    
    var displayTitle: String {
        if !searchText.isEmpty {
            return "Search Results"
        }
        return "Pokédex"
    }
    
    var resultCountText: String {
        if totalCount == 0 {
            return "No cards found"
        } else if totalCount == 1 {
            return "1 card"
        } else {
            return "\(totalCount) cards"
        }
    }
    
    // MARK: - Services
    
    private let pokemonService = PokemonTCGService.shared
    private var currentRequest: Task<Void, Never>?
    
    // MARK: - Constructors
    
    init() {
        Task {
            await fetch()
        }
    }
    
    init(searchTerm: String) {
        self.searchText = searchTerm
        Task {
            await searchCards()
        }
    }
    
    deinit {
        currentRequest?.cancel()
        currentRequest = nil
    }
    
    // MARK: - Configure
    
    private func configure(response: PokemonCardResponse, shouldAppend: Bool) async {
        if shouldAppend {
            pokemon.append(contentsOf: response.data)
        } else {
            pokemon = response.data
        }
        
        totalCount = response.totalCount
        hasMorePages = (currentPage * response.pageSize) < response.totalCount
        
        objectWillChange.send()
    }
    
    // MARK: - Fetch
    
    func refresh() async {
        if searchText.isEmpty {
            await fetch()
        } else {
            await searchCards()
        }
    }
    
    func fetch() async {
        guard currentRequest == nil else { return }
        
        isLoading = true
        errorMessage = nil
        showError = false
        currentPage = 1
        hasMorePages = true
        
        currentRequest = Task {
            await fetchCards(shouldAppend: false)
        }
        
        await currentRequest?.value
        currentRequest = nil
    }
    
    private func fetchCards(shouldAppend: Bool) async {
        print("🔄 fetchCards called - shouldAppend: \(shouldAppend), page: \(currentPage)")
        do {
            let response = try await pokemonService.fetchCards(
                page: currentPage,
                pageSize: 20
            )
            await configure(response: response, shouldAppend: shouldAppend)
        } catch {
            print("❌ fetchCards failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
            isLoading = false
            isSearching = false
            isLoadingMore = false
            objectWillChange.send()
        }
        
        isLoading = false
        isLoadingMore = false
    }
    
    func searchCards() async {
        guard !searchText.isEmpty else {
            await fetch()
            return
        }
        
        guard currentRequest == nil else { return }
        
        isSearching = true
        errorMessage = nil
        showError = false
        currentPage = 1
        hasMorePages = true
        
        currentRequest = Task {
            await searchCards(shouldAppend: false)
        }
        
        await currentRequest?.value
        currentRequest = nil
    }
    
    private func searchCards(shouldAppend: Bool) async {
        print("🔍 searchCards called - shouldAppend: \(shouldAppend), searchText: '\(searchText)', page: \(currentPage)")
        do {
            let response = try await pokemonService.fetchCards(
                page: currentPage,
                pageSize: 20,
                name: searchText
            )
            await configure(response: response, shouldAppend: shouldAppend)
        } catch {
            print("❌ searchCards failed: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showError = true
            isLoading = false
            isLoadingMore = false
            objectWillChange.send()
        }
        
        isSearching = false
        isLoadingMore = false
    }
} 
