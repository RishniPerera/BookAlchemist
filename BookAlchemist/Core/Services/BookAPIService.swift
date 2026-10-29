//
//  BookAPIService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-23.
//

import Foundation

class BookAPIService {
    static let shared = BookAPIService()
    
    // API Key
        private let apiKey = "AIzaSyDQ_fQcPRJShueJRFw5c_PzWR4IckVK3vU"
  
    // search for a specific book
    func searchBooks(query: String) async throws -> [Book] {
        // encode the text so spaces and symbols don't break the URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return []
        }
        
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(encodedQuery)&maxResults=20&key=\(apiKey)"
        return try await fetchAndDecode(urlString: urlString)
           }
        
        
    func fetchDiscoverBooks() async throws -> [Book] {
          // "bestsellers"
          let urlString = "https://www.googleapis.com/books/v1/volumes?q=bestsellers&maxResults=10&key=\(apiKey)"
          return try await fetchAndDecode(urlString: urlString)
      }
      
      
      // This function handles the network request and decoding to avoid repeat code
      private func fetchAndDecode(urlString: String) async throws -> [Book] {
          guard let url = URL(string: urlString) else {
              throw URLError(.badURL)
          }
          
          let (data, _) = try await URLSession.shared.data(from: url)
          
          // Print the raw JSON in Xcode console for debugging
          if let jsonString = String(data: data, encoding: .utf8) {
              print("API Response: \(jsonString.prefix(200))...")
          }
          
          let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
          return mapToBooks(decodedResponse)
      }
      
      // converts the Google API response into custom Book models
      private func mapToBooks(_ response: GoogleBooksResponse) -> [Book] {
          return response.items?.compactMap { item in
              guard let volumeInfo = item.volumeInfo else { return nil }
              
              let title = volumeInfo.title ?? "Unknown Title"
              let author = volumeInfo.authors?.first ?? "Unknown Author"
              let pages = volumeInfo.pageCount ?? 100
              
              // since Google sometimes uses "http" so change it to "https".
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

  // API Response Models
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
        
        
        
        
        
     
