//
//  ProfileView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct ProfileView: View {
    @State private var userProfile: UserProfile?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        Text("Profile Settings")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // Main Profile Card
                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color.appPrimary.opacity(0.15))
                                .frame(width: 90, height: 90)
                                .overlay(
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundColor(.appPrimary.opacity(0.5))
                                        .padding(5)
                                )
                            
                            Text(userProfile?.name ?? "Reader")
                                .font(.title2.bold())
                            
                            Text("Member since October 2024")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Divider().padding(.horizontal, 40)
                            
                            // Stats Row
                            HStack(spacing: 30) {
                                statItem(value: "17", label: "Books Read")
                                statItem(value: "\(userProfile?.readingStreak ?? 0)d", label: "Streak")
                                statItem(value: "\(userProfile?.currentLevel ?? 1)", label: "Level")
                                statItem(value: "\(userProfile?.xp ?? 0)", label: "Total XP")
                            }
                            .padding(.top, 5)
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.03), radius: 8)
                        .padding(.horizontal)
                        
                        // Settings Sections
                        VStack(alignment: .leading, spacing: 8) {
                            Text("READING PREFERENCES")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                settingRow(icon: "target", title: "Reading Goal", value: "24 books / year")
                                Divider().padding(.leading, 45)
                                settingRow(icon: "clock", title: "Reading Reminder", value: "Daily at 9:00 PM")
                                Divider().padding(.leading, 45)
                                settingRow(icon: "book", title: "Preferred Genres", value: "Self-Improvement")
                                Divider().padding(.leading, 45)
                                settingRow(icon: "star", title: "My Achievements", value: "")
                                Divider().padding(.leading, 45)
                                settingRow(icon: "chart.bar", title: "My Statistics", value: "")
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SECURITY")
                                .font(.caption.bold())
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Image(systemName: "faceid")
                                        .foregroundColor(.appPrimary)
                                        .frame(width: 30)
                                    Text("Face ID")
                                    Spacer()
                                    Toggle("", isOn: .constant(true))
                                        .tint(.appPrimary)
                                }
                                .padding()
                                
                                Divider().padding(.leading, 45)
                                
                                settingRow(icon: "lock.shield", title: "Account Settings", value: "")
                            }
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        // Sign Out Button
                        Button(action: {
                            // Logout logic later
                        }) {
                            Text("Sign Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                    }
                }
            }
           
            .task {
                if let userId = AuthService.shared.currentUserId {
                    if let profile = try? await FirestoreService.shared.fetchUserProfile(userId: userId) {
                        userProfile = profile
                    }
                }
            }
        }
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .foregroundColor(.appPrimary)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
    
    private func settingRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .frame(width: 30)
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
    }
}

#Preview {
    ProfileView()
}
