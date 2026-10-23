//
//  BookAPIService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-23.
//

import Foundation

class BookAPIService {
    static let shared = BookAPIService()
    
    // search the Google Books API
    func searchBooks(query: String) async throws -> [Book] {
        // Replace spaces with '+' for the URL
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(formattedQuery)&maxResults=20"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response
        let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
        
        // Map the API items to custom Book model
        return decodedResponse.items?.compactMap { item in
            let volumeInfo = item.volumeInfo
            
            // Sometimes the API doesn't return an author or page count, so provide defaults
            let author = volumeInfo.authors?.first ?? "Unknown Author"
            let pages = volumeInfo.pageCount ?? 100
            
            // Get the best available cover image
            let imageURL = volumeInfo.imageLinks?.thumbnail ?? volumeInfo.imageLinks?.smallThumbnail
            
            return Book(
                id: item.id,
                title: volumeInfo.title,
                author: author,
                coverURL: imageURL,
                totalPages: pages
            )
        } ?? []
    }
}

// API Response Models (Private to this file)
struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]?
}

struct GoogleBookItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let pageCount: Int?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}
