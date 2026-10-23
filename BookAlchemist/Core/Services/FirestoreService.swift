//
//  FirestoreService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    
    private let db = Firestore.firestore()
    
    // Fetch the user profile from Firebase
    func fetchUserProfile(userId: String) async throws -> UserProfile {
        let document = try await db.collection("users").document(userId).getDocument()
        return try document.data(as: UserProfile.self)
    }
    
    // Update XP and Level
    func updateUserStats(userId: String, xp: Int, level: Int) async throws {
        try await db.collection("users").document(userId).updateData([
            "xp": xp,
            "currentLevel": level
        ])
    }
    
    // Save a book to the user's library
    func saveBookToLibrary(userId: String, book: Book) async throws {
        try await db.collection("users").document(userId).collection("library").document(book.id).setData(from: book)
    }
}
