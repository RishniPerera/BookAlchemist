//
//  SearchView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-23.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Book] = []
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Search Bar (More reliable than .searchable)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search by books or authors...", text: $searchText)
                        .onSubmit {
                            // Trigger search when user presses "Return" on keyboard
                            print("DEBUG: Return key pressed. Searching for: \(searchText)")
                            performSearch(query: searchText)
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding()
                
                // Main Content
                if isSearching {
                    Spacer()
                    ProgressView("Searching Google Books...")
                    Spacer()
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    Spacer()
                    Text("No books found for '\(searchText)'.")
                        .foregroundColor(.gray)
                    Spacer()
                } else if searchResults.isEmpty {
                    // Show Categories
                    VStack(alignment: .leading) {
                        Text("Browse Categories")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CategoryChip(title: "Fiction", isSelected: false)
                                    .onTapGesture {
                                        searchText = "Fiction"
                                        performSearch(query: "Fiction")
                                    }
                                CategoryChip(title: "Mystery", isSelected: false)
                                    .onTapGesture {
                                        searchText = "Mystery"
                                        performSearch(query: "Mystery")
                                    }
                                CategoryChip(title: "Romance", isSelected: false)
                                    .onTapGesture {
                                        searchText = "Romance"
                                        performSearch(query: "Romance")
                                    }
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                    }
                } else {
                    // Show Results
                    List(searchResults) { book in
                        NavigationLink(destination: BookDetailsView(book: book)) {
                            HStack(spacing: 16) {
                                if let cover = book.coverURL, let url = URL(string: cover) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(8)
                                } else {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 60, height: 90)
                                        .overlay(Image(systemName: "book.closed").foregroundColor(.gray))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(book.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    Text(book.author)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("\(book.totalPages) pages")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxWidth: 700) // Restrict maximum width
                    .frame(maxWidth: .infinity, alignment: .center) // Center it on iPad
                }
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Search Books")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // The API Call function
    private func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        print("DEBUG: Starting search for \(query)")
        isSearching = true
        
        Task {
            do {
                let results = try await BookAPIService.shared.searchBooks(query: query)
                print("DEBUG: Found \(results.count) books")
                
                DispatchQueue.main.async {
                    self.searchResults = results
                    self.isSearching = false
                }
            } catch {
                print("DEBUG: Error fetching books - \(error)")
                DispatchQueue.main.async {
                    self.isSearching = false
                }
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? Color.appPrimary : Color.white)
            .foregroundColor(isSelected ? .white : .appTextPrimary)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 3)
    }
}
