//
//  AuthService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    
    // Firestore reference to users collection
    private let db = Firestore.firestore()
    
    // Keep track of the current user
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // Sign in as a guest (Anonymous)
    func signInAsGuest() async throws -> String {
        let result = try await Auth.auth().signInAnonymously()
        let userId = result.user.uid
        let userRef = db.collection("users").document(userId)
            
            do {
                let snapshot = try await userRef.getDocument()
                if !snapshot.exists {
                    // Create default user if document doesn't exist
                    let newUser = UserProfile(uid: userId, name: "Guest Reader", email: "", currentLevel: 1, xp: 0, readingStreak: 0)
                    try userRef.setData(from: newUser)
                }
            } catch {
                // If offline, still return the userId so the app can proceed
                print("Firestore offline or error: \(error)")
                // Optionally, attempt to write the default user anyway
                let newUser = UserProfile(uid: userId, name: "Guest Reader", email: "", currentLevel: 1, xp: 0, readingStreak: 0)
                try? userRef.setData(from: newUser)
            }
        
        return userId
    }
    
    // Sign out
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
