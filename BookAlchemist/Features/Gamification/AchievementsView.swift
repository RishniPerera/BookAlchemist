//
//  Achievements.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct AchievementsView: View {
    // Array of badges. Unlocked = true, Locked = false
    let badges = [
        ("book.fill", "First Book", true),
        ("flame.fill", "7-Day Streak", true),
        ("safari.fill", "Book Explorer", true),
        ("bookmark.fill", "10 Books", true),
        ("doc.text.fill", "500 Pages", true),
        ("trophy.fill", "Champion", false),
        ("star.fill", "Genre Master", false),
        ("moon.fill", "Night Owl", false),
        ("person.2.fill", "Social Reader", false)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Achievements")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        Text("5 of 25 achievements unlocked")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        // Featured Achievement Banner
                        ZStack(alignment: .bottomLeading) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(colors: [Color.brown, Color.orange.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .frame(height: 160)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "flame.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                
                                Text("7-Day Reader")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                
                                Text("Maintained a reading streak for 7 consecutive days.")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(20)
                            
                            // XP Badge top right
                            Text("+500 XP")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                                .padding(20)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        }
                        .padding(.horizontal)
                        
                        Text("Achievement Badges")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        // Grid of Badges
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(badges, id: \.1) { badge in
                                VStack(spacing: 8) {
                                    Image(systemName: badge.0)
                                        .font(.title2)
                                        .foregroundColor(badge.2 ? .appPrimary : .gray)
                                        .frame(width: 60, height: 60)
                                        .background(badge.2 ? Color.appPrimary.opacity(0.1) : Color.gray.opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    Text(badge.1)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(badge.2 ? .appTextPrimary : .gray)
                                    
                                    Text(badge.2 ? "UNLOCKED" : "LOCKED")
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundColor(badge.2 ? .appPrimary : .gray)
                                }
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.03), radius: 5)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    AchievementsView()
}
