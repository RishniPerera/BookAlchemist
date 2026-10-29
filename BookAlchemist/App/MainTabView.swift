//
//  MainTabView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//

import SwiftUI

struct MainTabView: View {
    // Track which tab is selected (Siri app shortcut)
        @Binding var isLoggedIn: Bool
        @State private var selectedTab = 0
        @StateObject private var router = AppRouter()
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Pass the router into HomeView
            // Home
            HomeView(router: router)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            // Search
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            // Challenges
            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "medal")
                }
                .tag(2)
            // Community
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left")
                }
                .tag(3)
            // Profile
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        // to match with figma ui color
        .tint(.appPrimary)
        
        
        
        

        // Listen for Siri Intents
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenCurrentReading"))) { _ in
            selectedTab = 0 // Go to Home
            // Push the Update Progress view (which is the "current reading")
            router.push(.updateProgress)
            
        }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenReadingProgress"))) { _ in
                    selectedTab = 0 // Go to Home
                    router.push(.updateProgress)
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenChallenge"))) { _ in
                    selectedTab = 2 // Go to Challenges tab
                }
            }
        }
#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
