//
//  MyLibraryView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-23.
//

import SwiftUI
import FirebaseAuth

struct MyLibraryView: View {
    @State private var savedBooks: [Book] = []
    @State private var isLoading = true
    
    // Grid layout: 2 columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading your library...")
            } else if savedBooks.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "books.vertical")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("Your library is empty.")
                        .font(.headline)
                    Text("Search for books and add them to your shelf!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(savedBooks) { book in
                            NavigationLink(destination: BookDetailsView(book: book)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    // Book Cover
                                    if let cover = book.coverURL, let url = URL(string: cover) {
                                        AsyncImage(url: url) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 140, height: 200)
                                        .cornerRadius(8)
                                        .clipped()
                                    } else {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 140, height: 200)
                                    }
                                    
                                    // Text
                                    Text(book.title)
                                        .font(.subheadline.bold())
                                        .foregroundColor(.appTextPrimary)
                                        .lineLimit(1)
                                    
                                    Text(book.author)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("My Library")
        .onAppear {
            loadLibrary()
        }
    }
    
    private func loadLibrary() {
        guard let userId = AuthService.shared.currentUserId else { return }
        
        Task {
            do {
                let books = try await FirestoreService.shared.fetchUserLibrary(userId: userId)
                DispatchQueue.main.async {
                    self.savedBooks = books
                    self.isLoading = false
                }
            } catch {
                print("Failed to load library: \(error)")
                isLoading = false
            }
        }
    }
}
