//
//  GamificationService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import Foundation
import FirebaseFirestore

class GamificationService {
    static let shared = GamificationService()
    
    // Logic: Every level requires 1000 XP
    let xpPerLevel = 1000
    
    // Firestore reference to save data
    private let db = Firestore.firestore()
    
    // Calculate the level based on XP
    func calculateLevel(for xp: Int) -> Int {
        // Example: 0-999 XP = Level 1, 1000-1999 XP = Level 2
        return (xp / xpPerLevel) + 1
    }
    
    // Calculate how much XP is needed for the NEXT level
    func xpToNextLevel(currentXp: Int) -> Int {
        let currentLevel = calculateLevel(for: currentXp)
        let nextLevelXpThreshold = currentLevel * xpPerLevel
        return nextLevelXpThreshold - currentXp
    }
    
    // Calculate percentage progress towards next level (0.0 to 1.0)
    func levelProgress(currentXp: Int) -> Double {
        let currentLevel = calculateLevel(for: currentXp)
        let baseXpForCurrentLevel = (currentLevel - 1) * xpPerLevel
        let xpInCurrentLevel = currentXp - baseXpForCurrentLevel
        return Double(xpInCurrentLevel) / Double(xpPerLevel)
    }
    
    // MARK: - New Addition for Phase 4
    // function to takes the user's current stats, adds the new XP,
    // recalculates their level, and pushes the update to Firebase.
    func addXP(userId: String, amount: Int, currentXp: Int, currentStreak: Int) async throws {
        let newXp = currentXp + amount
        let newLevel = calculateLevel(for: newXp)
        
        // Update the user document in Firestore
        try await db.collection("users").document(userId).updateData([
            "xp": newXp,
            "currentLevel": newLevel,
            "readingStreak": currentStreak
        ])
        
        print("Successfully added \(amount) XP. New total: \(newXp). Level: \(newLevel)")
    }
}
