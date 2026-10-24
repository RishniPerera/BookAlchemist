//
//  AppIntents.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-24.
//

import AppIntents
import SwiftUI


// View Current Reading
struct ViewCurrentReadingIntent: AppIntent {
    static var title: LocalizedStringResource = "View Current Reading"
    static var description = IntentDescription("Opens Book Alchemist to the book you are currently reading.")
    
    // This line is to tell iOS to open the app when the shortcut is run
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // NotificationCenter broadcast to tell the app what to do
        NotificationCenter.default.post(name: NSNotification.Name("OpenCurrentReading"), object: nil)
        return .result()
    }
}

// View Reading Progress
struct ViewReadingProgressIntent: AppIntent {
    static var title: LocalizedStringResource = "View Reading Progress"
    static var description = IntentDescription("Opens Book Alchemist to check how many pages you have left.")
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: NSNotification.Name("OpenReadingProgress"), object: nil)
        return .result()
    }
}

// Open Active Reading Challenge
struct OpenActiveChallengeIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Active Reading Challenge"
    static var description = IntentDescription("Opens Book Alchemist to your active reading challenge.")
    
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        NotificationCenter.default.post(name: NSNotification.Name("OpenChallenge"), object: nil)
        return .result()
    }
}

// The App Shortcuts Provider to makes them appear in Spotlight and Shortcuts app
struct BookAlchemistShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ViewCurrentReadingIntent(),
            phrases: [
                "Show my current book in \(.applicationName)",
                "What am I reading in \(.applicationName)"
            ],
            shortTitle: "Current Reading",
            systemImageName: "book.fill"
        )
        
        AppShortcut(
            intent: ViewReadingProgressIntent(),
            phrases: [
                "Check my reading progress in \(.applicationName)"
            ],
            shortTitle: "Reading Progress",
            systemImageName: "chart.bar.fill"
        )
        
        AppShortcut(
            intent: OpenActiveChallengeIntent(),
            phrases: [
                "Open my reading challenge in \(.applicationName)"
            ],
            shortTitle: "Active Challenge",
            systemImageName: "medal.fill"
        )
    }
}
