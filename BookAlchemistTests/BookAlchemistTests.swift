//
//  BookAlchemistTests.swift
//  BookAlchemistTests
//
//  Created by Student 1 on 2026-10-14.
//

import Testing
@testable import BookAlchemist

struct BookAlchemistTests {

    // Test 1: Check if the Book Progress Percentage calculates correctly
    @Test func testBookProgressPercentage() async throws {
        // Create a mock book: 200 total pages, currently on page 50
        let book = Book(
            id: "1",
            title: "Test Book",
            author: "Test Author",
            coverURL: nil,
            totalPages: 200,
            currentPage: 50
        )
        
        // 50 out of 200 pages should be exactly 25%
        #expect(book.progressPercentage == 25)
    }
    
    // Test 2: Check if the Gamification Level Math works correctly
    @Test func testGamificationLevelCalculation() async throws {
        let service = GamificationService.shared
        
        // User needs 1000 XP for Level 2.
        // 0 to 999 XP should be Level 1.
        #expect(service.calculateLevel(for: 0) == 1)
        #expect(service.calculateLevel(for: 500) == 1)
        #expect(service.calculateLevel(for: 999) == 1)
        
        // 1000 to 1999 XP should be Level 2.
        #expect(service.calculateLevel(for: 1000) == 2)
        
        // 2500 XP should be Level 3.
        #expect(service.calculateLevel(for: 2500) == 3)
    }
    
    // Test 3: Check if the XP Progress Bar calculates correctly
    @Test func testLevelProgressPercentage() async throws {
        let service = GamificationService.shared
        
        // If user has 500 XP, they are 50% of the way to Level 2.
        let progress = service.levelProgress(currentXp: 500)
        #expect(progress == 0.5)
    }
    
    // Test 4: Check how much XP is needed for the next level
    @Test func testXpToNextLevel() async throws {
        let service = GamificationService.shared
        
        // If user has 200 XP, they need 800 more to reach 1000 XP (Level 2).
        #expect(service.xpToNextLevel(currentXp: 200) == 800)
    }
}
