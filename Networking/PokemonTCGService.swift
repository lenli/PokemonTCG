import Foundation

class PokemonTCGService {
    static let shared = PokemonTCGService()
    private let baseURL = "https://api.pokemontcg.io/v2"
    private let session = URLSession.shared
    
    private init() {}
    
    func fetchCards(page: Int = 1, pageSize: Int = 20, name: String? = nil) async throws -> PokemonCardResponse {
        var components = URLComponents(string: "\(baseURL)/cards")!
        
        var queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        if let name = name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "q", value: "name:\"\(name)*\""))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📡 Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ API Error (\(httpResponse.statusCode)): \(errorMessage)")
            throw NetworkError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PokemonCardResponse.self, from: data)
            print("✅ Successfully fetched \(result.data.count) cards (page \(result.page) of \(result.totalCount) total)")
            return result
        } catch {
            print("❌ Decoding Error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(String(jsonString.prefix(500)))...")
            }
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchCard(id: String) async throws -> PokemonCardSingleResponse {
        guard let url = URL(string: "\(baseURL)/cards/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(PokemonCardSingleResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchSets(page: Int = 1, pageSize: Int = 20, name: String? = nil) async throws -> PokemonSetResponse {
        var components = URLComponents(string: "\(baseURL)/sets")!
        
        var queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        if let name = name, !name.isEmpty {
            queryItems.append(URLQueryItem(name: "q", value: "name:\"\(name)*\""))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching Sets: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📡 Sets Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ Sets API Error (\(httpResponse.statusCode)): \(errorMessage)")
            throw NetworkError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PokemonSetResponse.self, from: data)
            print("✅ Successfully fetched \(result.data.count) sets (page \(result.page) of \(result.totalCount) total)")
            return result
        } catch {
            print("❌ Sets Decoding Error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(String(jsonString.prefix(500)))...")
            }
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchSet(id: String) async throws -> PokemonSetSingleResponse {
        guard let url = URL(string: "\(baseURL)/sets/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching Set: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📡 Set Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ Set API Error (\(httpResponse.statusCode)): \(errorMessage)")
            throw NetworkError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PokemonSetSingleResponse.self, from: data)
            print("✅ Successfully fetched set: \(result.data.name ?? "Unknown")")
            return result
        } catch {
            print("❌ Set Decoding Error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(String(jsonString.prefix(500)))...")
            }
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchCardsBySet(setId: String, page: Int = 1, pageSize: Int = 20) async throws -> PokemonCardResponse {
        var components = URLComponents(string: "\(baseURL)/cards")!
        
        let queryItems = [
            URLQueryItem(name: "q", value: "set.id:\(setId)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching Cards by Set: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📡 Cards by Set Response Status: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ Cards by Set API Error (\(httpResponse.statusCode)): \(errorMessage)")
            throw NetworkError.apiError(httpResponse.statusCode, errorMessage)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PokemonCardResponse.self, from: data)
            print("✅ Successfully fetched \(result.data.count) cards from set \(setId)")
            return result
        } catch {
            print("❌ Cards by Set Decoding Error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(String(jsonString.prefix(500)))...")
            }
            throw NetworkError.decodingError(error)
        }
    }
} 