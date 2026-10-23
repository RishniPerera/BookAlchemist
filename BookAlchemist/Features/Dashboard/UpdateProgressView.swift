//
//  UpdateProgressView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UpdateProgressView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPage: Double = 195
    let totalPages: Double = 300
    
    // State variables to handle saving and fetching real user data
    @State private var isSaving = false
    @State private var userProfile: UserProfile?
    
    // Calculate percentage based on slider
    var percentage: Int {
        Int((currentPage / totalPages) * 100)
    }
    
    var body: some View {
        // Wrapped in ScrollView so it fits on all screen sizes
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // Header Book Info
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 50, height: 75)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("The Last Oracle")
                            .font(.headline)
                        Text("by Helena Rostova")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.03), radius: 8)
                
                // Circular Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.15), lineWidth: 18)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(currentPage / totalPages))
                        .stroke(Color.appAccent, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: currentPage)
                    
                    VStack(spacing: 4) {
                        Text("\(percentage)%")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                        Text("COMPLETED")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .tracking(1)
                    }
                }
                .frame(width: 180, height: 180)
                .padding(.vertical, 10)
                
                // Slider Section
                VStack(spacing: 12) {
                    HStack {
                        Text("CURRENT POSITION")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Int(currentPage)) / \(Int(totalPages)) pages")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    
                    Slider(value: $currentPage, in: 0...totalPages, step: 1)
                        .tint(.appAccent)
                    
                    HStack {
                        Text("0")
                        Spacer()
                        Text("300")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                
                // Stats Row
                HStack(spacing: 0) {
                    statColumn(value: "\(Int(currentPage))", title: "Current Page", color: .blue)
                    Divider().frame(height: 40)
                    statColumn(value: "\(Int(totalPages))", title: "Total Pages", color: .purple)
                    Divider().frame(height: 40)
                    statColumn(value: "\(Int(totalPages - currentPage))", title: "Remaining", color: .red)
                }
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [Color.blue.opacity(0.1), Color.pink.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(16)
                
                // Streak Banner
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("7 Day Streak! • +1,250 XP")
                            .font(.subheadline.bold())
                        Text("You're in the top 10% of readers this week. Keep it up!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.yellow.opacity(0.15))
                .cornerRadius(16)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        // NEW: Call the save function
                        saveProgressAndEarnXP()
                    }) {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appPrimary)
                                .cornerRadius(16)
                        } else {
                            Text("Update Progress")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appPrimary)
                                .cornerRadius(16)
                        }
                    }
                    .disabled(isSaving)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Mark as Completed")
                            .font(.headline)
                            .foregroundColor(.appPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .padding()
        }
        .navigationTitle("Update Progress")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground.ignoresSafeArea())
        // Fetch user data when the view opens
        .task {
            if let userId = AuthService.shared.currentUserId {
                userProfile = try? await FirestoreService.shared.fetchUserProfile(userId: userId)
            }
        }
    }
    
    // The logic function to save to Firebase
    private func saveProgressAndEarnXP() {
        guard let userId = AuthService.shared.currentUserId, let profile = userProfile else { return }
        
        isSaving = true
        
        Task {
            do {
                // Award 50 XP for reading
                let xpEarned = 50
                
                // Call the Gamification Service to update Firebase
                try await GamificationService.shared.addXP(
                    userId: userId,
                    amount: xpEarned,
                    currentXp: profile.xp,
                    currentStreak: profile.readingStreak // Keep streak same for this example
                )
                
                // Go back to the previous screen
                DispatchQueue.main.async {
                    isSaving = false
                    dismiss()
                }
            } catch {
                print("Failed to update XP: \(error)")
                isSaving = false
            }
        }
    }
    
    // Small helper to keep the HStack clean
    private func statColumn(value: String, title: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundColor(color)
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        UpdateProgressView()
    }
}
