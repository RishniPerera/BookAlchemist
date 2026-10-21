//
//  MainTabView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Home
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            // Search
            Text("Search Placeholder")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            // Challenges
            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "medal")
                }
            
            // Community
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left")
                }
            
            // Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        // to match with figma ui color
        .tint(.appPrimary)
    }
}

#Preview {
    MainTabView()
}
