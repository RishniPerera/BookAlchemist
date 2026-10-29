//
//  BookDetailsView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI
import FirebaseAuth

struct BookDetailsView: View {
    // Accept the real book from the search results
    var book: Book
    
    @State private var selectedStatus: String = "Want to Read"
    let statuses = ["Want to Read", "Reading", "Completed"]
    
    // State variables for saving to Firebase
    @State private var isSaving = false
    @State private var showSuccess = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Real Cover Image from the API
                if let cover = book.coverURL, let url = URL(string: cover) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 160, height: 240)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 10)
                } else {
                    // Fallback if no image exists
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.7, green: 0.5, blue: 0.3))
                        .frame(width: 160, height: 240)
                        .overlay(
                            Image(systemName: "book.closed.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 10)
                }
                
                // Real Title & Author
                VStack(spacing: 8) {
                    Text(book.title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("by \(book.author)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Text("\(book.totalPages) pages")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        // Keeping the hardcoded rating UI from your Figma design
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                        Text("4.5 (1240 ratings)")
                            .font(.caption)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                // Working "Add to Library" Button
                Button(action: {
                    saveBookToLibrary()
                }) {
                    if isSaving {
                        ProgressView().tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .cornerRadius(16)
                    } else {
                        Text("+ Add to Library")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                .disabled(isSaving)
                
                // Start Reading Button
                NavigationLink(destination: ReaderView(book: book)) {
                    Text("Start Reading Now")
                        .font(.headline)
                        .foregroundColor(.appPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                // Reading Status Segmented Control
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reading Status")
                        .font(.headline)
                    
                    HStack(spacing: 0) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedStatus == status ? Color.appPrimary : Color.white)
                                .foregroundColor(selectedStatus == status ? .white : .gray)
                                .onTapGesture {
                                    selectedStatus = status
                                }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // About this book
                VStack(alignment: .leading, spacing: 8) {
                    Text("About this Book")
                        .font(.headline)
                    Text("At the edge of the Mediterranean, the lost library contains every secret never spoken. When Clara uncovers a brass astrolabe hidden in the dust, she unwittingly awakens a modern-day oracle. A breathtaking tale of fate, cosmic balance, and the preservation of forgotten memories.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Rating Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Rating")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.appAccent)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Add Note Section
                Button(action: {}) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Add Personal Note")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .foregroundColor(.appTextPrimary)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground.ignoresSafeArea())
        // 6. Alert to show success message
        .alert("Added to Library!", isPresented: $showSuccess) {
            Button("OK") { dismiss() }
        } message: {
            Text("\(book.title) is now on your shelf.")
        }
    }
    
    // The Firebase logic to save the book
    private func saveBookToLibrary() {
        guard let userId = AuthService.shared.currentUserId else { return }
        
        isSaving = true
        
        Task {
            do {
                //  pass the user's ID and the book data to Firestore
                try await FirestoreService.shared.saveBookToLibrary(userId: userId, book: book)
                isSaving = false
                showSuccess = true
            } catch {
                print("Error saving book: \(error)")
                isSaving = false
            }
        }
    }
}

#Preview {
    // have to pass a dummy book for the preview to work
    NavigationStack {
        BookDetailsView(book: Book(id: "1", title: "The Last Oracle", author: "Helena Rostova", coverURL: nil, totalPages: 300))
    }
}
