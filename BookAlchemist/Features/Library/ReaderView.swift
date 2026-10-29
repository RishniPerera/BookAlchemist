//
//  ReaderView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-27.
//

import SwiftUI

struct ReaderView: View {
    var book: Book
    
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    @State private var isFinishing = false
    @State private var showSuccessAlert = false
    
    // 5 pages of text of the selected book
    var pages: [String] {
        let baseText = book.title + "\n\n" + (book.description ?? "Once upon a time, there was a reader who loved to read. They opened this book and found a world of wonder.")
        
        // repeating text to ensure the book is long enough to have multiple pages
        let filler = String(repeating: "The story continues. Every page brings a new adventure. The characters travel through mystical lands, discovering ancient secrets and forging unbreakable bonds. ", count: 15)
        
        let fullText = baseText + "\n\n" + filler
        
        // Split the text into chunks of 500 characters to fit to the screen
        return stride(from: 0, to: fullText.count, by: 500).map { index in
            let start = fullText.index(fullText.startIndex, offsetBy: index)
            let end = fullText.index(start, offsetBy: min(500, fullText.count - index))
            return String(fullText[start..<end])
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.appTextPrimary)
                        .padding()
                }
                Spacer()
                Text(book.title)
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                Spacer()
                // Page Counter
                Text("Page \(currentPage + 1) of \(pages.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 3, y: 3)
            
            // The actual reading text
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    ScrollView {
                        Text(pages[index])
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .lineSpacing(8)
                            .padding(30)
                            .foregroundColor(.appTextPrimary)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color(red: 0.98, green: 0.96, blue: 0.92)) // Book paper color
            
            // Bottom Navigation / Finish Button
            HStack {
                // Left Arrow
                Button(action: {
                    withAnimation { currentPage = max(0, currentPage - 1) }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                        .foregroundColor(currentPage == 0 ? .gray.opacity(0.3) : .appPrimary)
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                // Show Finish Button only on the last page
                if currentPage == pages.count - 1 {
                    Button(action: finishBook) {
                        if isFinishing {
                            ProgressView().tint(.white)
                        } else {
                            Text("Finish Book ")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.appAccent)
                    .cornerRadius(20)
                    .shadow(color: .appAccent.opacity(0.4), radius: 5, y: 3)
                } else {
                    Text("Swipe or tap arrows to read")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Right Arrow
                Button(action: {
                    withAnimation { currentPage = min(pages.count - 1, currentPage + 1) }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .padding()
                        .foregroundColor(currentPage == pages.count - 1 ? .gray.opacity(0.3) : .appPrimary)
                }
                .disabled(currentPage == pages.count - 1)
            }
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 5, y: -5)
        }
        .navigationBarHidden(true)
        .alert("Book Completed!", isPresented: $showSuccessAlert) {
            Button("Awesome!") { dismiss() }
        } message: {
            Text("You earned 100 XP and increased your reading streak. Check your profile!")
        }
    }
    
    private func finishBook() {
        guard let userId = AuthService.shared.currentUserId else { return }
        isFinishing = true
        
        Task {
            do {
                // Fetch current profile to get existing XP
                let profile = try await FirestoreService.shared.fetchUserProfile(userId: userId)
                
                // Complete the book and update Firebase
                _ = try await FirestoreService.shared.completeBook(userId: userId, book: book, currentProfile: profile)
                
                DispatchQueue.main.async {
                    isFinishing = false
                    showSuccessAlert = true
                }
            } catch {
                print("Error finishing book: \(error)")
                isFinishing = false
            }
        }
    }
}
