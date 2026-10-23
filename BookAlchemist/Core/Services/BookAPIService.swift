//
//  BookAPIService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-23.
//

import Foundation

class BookAPIService {
    static let shared = BookAPIService()
    
    func searchBooks(query: String) async throws -> [Book] {
        // encode the text so spaces and symbols don't break the URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)&maxResults=20&key=AIzaSyDQ_fQcPRJShueJRFw5c_PzWR4IckVK3vU"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Print the raw JSON in Xcode console to see what Google is actually sending
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString.prefix(200))...") // Just print the start
        }
        
        let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
        
        return decodedResponse.items?.compactMap { item in
            guard let volumeInfo = item.volumeInfo else { return nil }
            
            // Safely unwrap everything
            let title = volumeInfo.title ?? "Unknown Title"
            let author = volumeInfo.authors?.first ?? "Unknown Author"
            let pages = volumeInfo.pageCount ?? 100
            
            // Google sometimes uses "http" instead of "https" for images. iOS blocks "http" by default.
            var imageURL = volumeInfo.imageLinks?.thumbnail ?? volumeInfo.imageLinks?.smallThumbnail
            imageURL = imageURL?.replacingOccurrences(of: "http://", with: "https://")
            
            return Book(
                id: item.id ?? UUID().uuidString,
                title: title,
                author: author,
                coverURL: imageURL,
                totalPages: pages
            )
        } ?? []
    }
}

// API Response Models (Made optional to prevent crashes)
struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let id: String?
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let pageCount: Int?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
