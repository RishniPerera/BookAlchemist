//
//  LeaderboardView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LeaderboardView: View {
    @State private var userXp: Int = 0
    @State private var userName: String = "You"
    
    // data for other readers to the leaderboard
    let mockReaders = [
        ("Sachi12", 1450),
        ("Rishni perera", 920),
        ("zayn008", 540),
        ("readerX03", 210)
    ]
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Top 3 Podium
                    HStack(alignment: .bottom, spacing: 15) {
                        podiumItem(name: mockReaders[1].0, xp: mockReaders[1].1, rank: 2, height: 100, color: .gray)
                        podiumItem(name: "Sarah", xp: mockReaders[0].1, rank: 1, height: 130, color: .yellow) // Top player mock
                        podiumItem(name: mockReaders[2].0, xp: mockReaders[2].1, rank: 3, height: 80, color: .brown)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    // List of remaining players
                    VStack(spacing: 12) {
                        // Your Real Row
                        leaderboardRow(rank: 4, name: "\(userName) (You)", xp: userXp, isCurrentUser: true)
                        
                        // Mock Rows
                        leaderboardRow(rank: 5, name: mockReaders[3].0, xp: mockReaders[3].1, isCurrentUser: false)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Global Leaderboard")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Fetch the real user's XP from Firebase
            if let userId = AuthService.shared.currentUserId {
                if let profile = try? await FirestoreService.shared.fetchUserProfile(userId: userId) {
                    userXp = profile.xp
                    userName = profile.name
                }
            }
        }
    }
    
    // Helper UI components
    private func podiumItem(name: String, xp: Int, rank: Int, height: CGFloat, color: Color) -> some View {
        VStack {
            Text(name)
                .font(.caption.bold())
                .lineLimit(1)
            Text("\(xp) XP")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(Text("\(rank)").font(.headline).foregroundColor(color))
            
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.1))
                .frame(height: height)
                .overlay(
                    Text("#\(rank)")
                        .font(.title2.bold())
                        .foregroundColor(color)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 10)
                )
        }
    }
    
    private func leaderboardRow(rank: Int, name: String, xp: Int, isCurrentUser: Bool) -> some View {
        HStack {
            Text("\(rank)")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: 30)
            
            Circle()
                .fill(isCurrentUser ? Color.appPrimary.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(isCurrentUser ? .appPrimary : .gray)
                )
            
            Text(name)
                .font(.subheadline.bold())
                .foregroundColor(isCurrentUser ? .appPrimary : .appTextPrimary)
            
            Spacer()
            
            Text("\(xp) XP")
                .font(.subheadline.bold())
                .foregroundColor(.appAccent)
        }
        .padding()
        .background(isCurrentUser ? Color.appPrimary.opacity(0.05) : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrentUser ? Color.appPrimary.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
