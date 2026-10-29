//
//  ChallengesView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI
import FirebaseAuth

struct ChallengesView: View {
    // Hardcoded data for testing
    let activeChallenge = "Monthly Reading Challenge"
    let activeProgress = "3 / 5 books"
    let activePercentage: Double = 0.6
    
    // State variables to handle saving to Firebase
    @State private var hasJoined = false
    @State private var isJoining = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Reading Challenges")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // Featured Challenge Card
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("FEATURED CHALLENGE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.appAccent)
                                    .tracking(1)
                                
                                Spacer()
                                
                                Text("500 XP")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            Text(activeChallenge)
                                .font(.title2.bold())
                            
                            Text("Complete 5 books this month")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("Progress")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(activeProgress)
                                    .font(.subheadline.bold())
                            }
                            .padding(.top, 4)
                            
                            ProgressView(value: activePercentage)
                                .tint(.appAccent)
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            // Button with Firebase Logic
                            Button(action: {
                                joinFeaturedChallenge()
                            }) {
                                if isJoining {
                                    ProgressView()
                                        .tint(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.appPrimary)
                                        .cornerRadius(12)
                                } else {
                                    Text(hasJoined ? "Challenge Joined! ✓" : "Join Challenge")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(hasJoined ? Color.green : Color.appPrimary)
                                        .cornerRadius(12)
                                }
                            }
                            .disabled(hasJoined || isJoining)
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                        .padding(.horizontal)
                        
                        // Explore Challenges
                        Text("Explore Challenges")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        VStack(spacing: 12) {
                            let mockChallenges = getMockChallenges()
                            
                            // Wrapped in NavigationLink so users can tap them
                            NavigationLink(destination: ChallengeDetailsView(challenge: mockChallenges[0])) {
                                challengeRow(icon: "flame", title: mockChallenges[0].title, subtitle: mockChallenges[0].description, progress: 0.5, xp: "+\(mockChallenges[0].xpReward) XP", color: .orange)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ChallengeDetailsView(challenge: mockChallenges[1])) {
                                challengeRow(icon: "book", title: mockChallenges[1].title, subtitle: mockChallenges[1].description, progress: 0.62, xp: "+\(mockChallenges[1].xpReward) XP", color: .blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ChallengeDetailsView(challenge: mockChallenges[2])) {
                                challengeRow(icon: "magnifyingglass", title: mockChallenges[2].title, subtitle: mockChallenges[2].description, progress: 0.33, xp: "+\(mockChallenges[2].xpReward) XP", color: .purple)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                        
                        // Completed Section
                        Text("Completed")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .font(.title3)
                            
                            VStack(alignment: .leading) {
                                Text("Classic Literature Intro")
                                    .font(.headline)
                                Text("Read 2 classical books")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("+150 XP")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .opacity(0.7)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: 600) // Limits the width on iPad
                    .frame(maxWidth: .infinity) // Centers it on the screen
                }
            }
            // Check if the user has already joined when the view loads
            .task {
                checkIfJoined()
            }
        }
    }
    
    // Helper Functions
    // Helper to create challenges and it can pass around to the Details screen
    private func getMockChallenges() -> [Challenge] {
        return [
            Challenge(id: "streak_7", title: "7 Day Reading Streak", description: "Read every day for a week", xpReward: 150, targetBooks: 7),
            Challenge(id: "pages_500", title: "Read 500 Pages", description: "Track your total page count", xpReward: 200, targetBooks: 500),
            Challenge(id: "mystery_month", title: "Mystery Month", description: "Read 3 mystery novels", xpReward: 175, targetBooks: 3)
        ]
    }
    
    // Helper to keep the row design clean
    private func challengeRow(icon: String, title: String, subtitle: String, progress: Double, xp: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary) // Ensures text stays dark inside NavigationLink
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ProgressView(value: progress)
                    .tint(.appPrimary)
                    .padding(.top, 4)
            }
            
            Spacer()
            
            Text(xp)
                .font(.caption.bold())
                .foregroundColor(.gray)
                .padding(.leading, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
    }
    
    // Function to save the featured challenge to Firebase
    private func joinFeaturedChallenge() {
        guard let userId = AuthService.shared.currentUserId else { return }
        isJoining = true
        
        let challenge = Challenge(
            id: "monthly_reading_challenge_2026", // Fixed ID to avoid duplicates
            title: activeChallenge,
            description: "Complete 5 books this month",
            xpReward: 500,
            targetBooks: 5
        )
        
        Task {
            do {
                try await FirestoreService.shared.joinChallenge(userId: userId, challenge: challenge)
                DispatchQueue.main.async {
                    self.isJoining = false
                    self.hasJoined = true
                }
            } catch {
                print("Error joining challenge: \(error)")
                DispatchQueue.main.async {
                    self.isJoining = false
                }
            }
        }
    }
    
    // Function to check if the user already joined
    private func checkIfJoined() {
        guard let userId = AuthService.shared.currentUserId else { return }
        
        Task {
            if let challenges = try? await FirestoreService.shared.fetchUserChallenges(userId: userId) {
                let isAlreadyJoined = challenges.contains { $0.id == "monthly_reading_challenge_2026" }
                DispatchQueue.main.async {
                    self.hasJoined = isAlreadyJoined
                }
            }
        }
    }
}

#Preview {
    ChallengesView()
}
