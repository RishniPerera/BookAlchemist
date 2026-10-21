//
//  ChallengesView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct ChallengesView: View {
    // Hardcoded data for testing
    let activeChallenge = "Monthly Reading Challenge"
    let activeProgress = "3 / 5 books"
    let activePercentage: Double = 0.6
    
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
                            
                            Button(action: {
                                // Will route to Challenge Details later
                            }) {
                                Text("Continue Challenge")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.appPrimary)
                                    .cornerRadius(12)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                        .padding(.horizontal)
                        
                        Text("Explore Challenges")
                            .font(.title3.bold())
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // List of other challenges
                        VStack(spacing: 12) {
                            challengeRow(icon: "flame", title: "7 Day Reading Streak", subtitle: "Read every day for a week", progress: 0.5, xp: "+150 XP", color: .orange)
                            challengeRow(icon: "book", title: "Read 500 Pages", subtitle: "Track your total page count", progress: 0.62, xp: "+200 XP", color: .blue)
                            challengeRow(icon: "magnifyingglass", title: "Mystery Month", subtitle: "Read 3 mystery novels", progress: 0.33, xp: "+175 XP", color: .purple)
                        }
                        .padding(.horizontal)
                        
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
                }
            }
        }
    }
    
    // Helper to keep the code clean
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
}

#Preview {
    ChallengesView()
}
