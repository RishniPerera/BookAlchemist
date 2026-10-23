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
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if searchText.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Browse Categories")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                CategoryChip(title: "Fiction", isSelected: true)
                                CategoryChip(title: "Mystery", isSelected: false)
                                CategoryChip(title: "Romance", isSelected: false)
                                CategoryChip(title: "Fantasy", isSelected: false)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                } else {
                    if isSearching {
                        ProgressView("Searching...")
                    } else if searchResults.isEmpty {
                        Text("No books found. Try a different search.")
                            .foregroundColor(.gray)
                    } else {
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
                    }
                }
            }
            .navigationTitle("Search Books")
            .searchable(text: $searchText, prompt: "Search by title or author...")
            .onChange(of: searchText) { oldValue, newValue in
                if newValue.count > 2 {
                    Task {
                        isSearching = true
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        
                        if !newValue.isEmpty {
                            do {
                                searchResults = try await BookAPIService.shared.searchBooks(query: newValue)
                            } catch {
                                print("Search failed: \(error)")
                            }
                        }
                        isSearching = false
                    }
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
