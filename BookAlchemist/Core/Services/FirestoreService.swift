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
    
    private let db = Firestore.firestore(database: "default")
        
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
            try await db.collection("users").document(userId)
                .collection("library")
                .document(book.id).setData(from: book)
        }
        
        // Fetch all books from the user's library
        func fetchUserLibrary(userId: String) async throws -> [Book] {
            let snapshot = try await db.collection("users").document(userId).collection("library").getDocuments()
            
            // Decode the documents into our Book model
            return snapshot.documents.compactMap { document in
                try? document.data(as: Book.self)
            }
        }
   
    // Gamification Engine
       // function to handle finishing a book, awarding XP, and updating the level
       func completeBook(userId: String, book: Book, currentProfile: UserProfile) async throws -> UserProfile {
           // Award 100 XP for finishing a book
           let xpEarned = 100
           let newXp = currentProfile.xp + xpEarned
           
           // Calculate new Level using our Gamification Service
           let newLevel = GamificationService.shared.calculateLevel(for: newXp)
           
           // Update the Book status to "Completed" in the library
           var completedBook = book
           completedBook.status = "Completed"
           completedBook.currentPage = book.totalPages
           try await saveBookToLibrary(userId: userId, book: completedBook)
           
           // Update the User Profile in Firebase (XP, Level, and Streak)
           let userRef = db.collection("users").document(userId)
           try await userRef.updateData([
               "xp": newXp,
               "currentLevel": newLevel,
               "readingStreak": currentProfile.readingStreak + 1
           ])
           
           // eturn the updated profile so the UI can refresh immediately
           var updatedProfile = currentProfile
           updatedProfile.xp = newXp
           updatedProfile.currentLevel = newLevel
           updatedProfile.readingStreak += 1
           
           return updatedProfile
       }
    
    // Save a new community post to Firestore
       func savePost(userId: String, name: String, content: String) async throws {
           let post = CommunityPost(
               authorName: name,
               authorId: userId,
               content: content,
               timestamp: Date()
           )
           try db.collection("community_posts").document(post.id).setData(from: post)
       }
       
       // Fetch all community posts (ordered by newest first)
       func fetchPosts() async throws -> [CommunityPost] {
           let snapshot = try await db.collection("community_posts")
               .order(by: "timestamp", descending: true)
               .getDocuments()
           
           return snapshot.documents.compactMap { document in
               try? document.data(as: CommunityPost.self)
           }
       }
       
       // Save a joined challenge under the user's profile
       func joinChallenge(userId: String, challenge: Challenge) async throws {
           try await db.collection("users").document(userId)
               .collection("challenges")
               .document(challenge.id)
               .setData(from: challenge)
       }
       
       // Fetch the challenges the user has joined
       func fetchUserChallenges(userId: String) async throws -> [Challenge] {
           let snapshot = try await db.collection("users").document(userId)
               .collection("challenges")
               .getDocuments()
           
           return snapshot.documents.compactMap { document in
               try? document.data(as: Challenge.self)
           }
       }
   }
