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
    private let db = Firestore.firestore(database: "default")
    
    // Keep track of the current user
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // Sign up a new user
    func signUpWithEmail(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let userId = result.user.uid
    
        // Create their profile in Firestore
        let userRef = db.collection("users").document(userId)
        let newUser = UserProfile(
            uid: userId,
            name: email.components(separatedBy: "@").first ?? "Reader", // Use email prefix as the name
            email: email,
            currentLevel: 1,
            xp: 0,
            readingStreak: 0
        )
        try userRef.setData(from: newUser)
        
        return userId
    }
    
    // Log in an existing user
    func signInWithEmail(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }

    // Sign in as a guest (Anonymous user)
    func signInAsGuest() async throws -> String {
        let result = try await Auth.auth().signInAnonymously()
        let userId = result.user.uid
    // Check if the user document exists in Firestore
        let userRef = db.collection("users").document(userId)
        do {
        let snapshot = try await userRef.getDocument()
        
    // If the document doesn't exist, create a fresh profile
                        if !snapshot.exists {
                            let newUser = UserProfile(
                                uid: userId,
                                name: "Guest Reader",
                                email: "",
                                currentLevel: 1,
                                xp: 0,
                                readingStreak: 0
                            )
                            
    // Save it to Firebase
                         try userRef.setData(from: newUser)
                            print("DEBUG: Created new user in Firestore with UID: \(userId)")
                        } else {
                            print("DEBUG: Returning user found with UID: \(userId)")
                        }
                    } catch {
                        print("Firestore error during login: \(error.localizedDescription)")
                    }
                
                    return userId
                }
                
                func signOut() throws {
                    try Auth.auth().signOut()
                }
            }
