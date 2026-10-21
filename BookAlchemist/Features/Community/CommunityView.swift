//
//  CommunityView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Header
                        HStack {
                            Text("Reader Community")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .foregroundColor(.appTextPrimary)
                            }
                            
                            Circle()
                                .fill(Color.appPrimary.opacity(0.2))
                                .frame(width: 35, height: 35)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Featured Challenge Banner
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(.yellow)
                                Text("FEATURED COMMUNITY CHALLENGE")
                                    .font(.caption.bold())
                                    .foregroundColor(.appAccent)
                                Spacer()
                                Text("7 Days Left")
                                    .font(.caption2)
                                    .padding(4)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(4)
                            }
                            
                            Text("Autumn Pages Marathon")
                                .font(.title3.bold())
                            
                            Text("Join 1,240 readers worldwide in completing at least three books this month.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("Your Progress: 2 of 3 Books")
                                    .font(.caption.bold())
                                Spacer()
                                Text("66%")
                                    .font(.caption.bold())
                            }
                            
                            ProgressView(value: 0.66)
                                .tint(.appAccent)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                        .padding(.horizontal)
                        
                        Text("READING FEED")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                            .tracking(1)
                            .padding(.horizontal)
                        
                        // Community Post 1
                        postCard(
                            userName: "Sashini Perera",
                            time: "2 hours ago",
                            action: "Completed",
                            actionColor: .green,
                            content: "Just finished reading **The Alchemist** by Paulo Coelho. Absolutely spellbound by the simple yet profound wisdom on finding your Personal Legend.",
                            hasBook: true,
                            likes: "24",
                            comments: "8"
                        )
                        
                        // Community Post 2
                        postCard(
                            userName: "ReaderR12",
                            time: "5 hours ago",
                            action: "Badge Earned",
                            actionColor: .orange,
                            content: "Completed 30 minutes of daily reading for 7 consecutive days! Keep the flame burning.",
                            hasBook: false,
                            likes: "42",
                            comments: "3"
                        )
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }
    
    // Reusable post view to avoid repeating code
    private func postCard(userName: String, time: String, action: String, actionColor: Color, content: String, hasBook: Bool, likes: String, comments: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // User Info Header
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(userName)
                        .font(.headline)
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(action)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(actionColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(actionColor.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Post Content
            Text(.init(content)) // Using .init to parse markdown formatting 
                .font(.subheadline)
                .lineSpacing(4)
            
            // Optional Book attachment
            if hasBook {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 45, height: 65)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("The Alchemist")
                            .font(.subheadline.bold())
                        Text("Paulo Coelho • 163 pages")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        HStack(spacing: 2) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.yellow)
                            }
                            Text("5.0 Rating")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                        }
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
            
            Divider()
            
            // Bottom Actions
            HStack(spacing: 20) {
                Label(likes, systemImage: "heart")
                Label(comments, systemImage: "bubble.left")
                Spacer()
                Text("View Profile")
                    .font(.caption.bold())
                    .foregroundColor(.appAccent)
            }
            .foregroundColor(.gray)
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    CommunityView()
}
