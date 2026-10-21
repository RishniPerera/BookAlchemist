//
//  HomeView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var router = AppRouter()
    
    // Hardcoded user data for testing
    let userName = "Sachindri"
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Top Header
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("BOOK ALCHEMIST")
                                .font(.custom("Avenir-Black", size: 14))
                                .foregroundColor(.appPrimary)
                                .tracking(1.5)
                            
                            Text("Good Morning, \(userName) 👋")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundColor(.appTextPrimary)
                        }
                        
                        Spacer()
                        
                        // Profile Avatar Placeholder
                        Circle()
                            .fill(Color.appPrimary.opacity(0.15))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.appPrimary)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Level & XP Card
                    VStack(spacing: 12) {
                        HStack {
                            Text("CURRENT RANK")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.appAccent)
                                Text("6 Day Streak")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.appAccent.opacity(0.1))
                            .cornerRadius(10)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("820 XP")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.15))
                            .cornerRadius(10)
                        }
                        
                        HStack {
                            Text("Level 3")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                            Text("82% completed")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        // Custom Progress Bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(height: 8)
                                    .foregroundColor(Color.gray.opacity(0.2))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: geo.size.width * 0.82, height: 8)
                                    .foregroundColor(.appPrimary)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("180 XP to Level 6")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Active Challenge Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "book.closed.fill")
                                .font(.caption)
                                .foregroundColor(.appPrimary)
                            Text("ACTIVE CHALLENGE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.appPrimary)
                        }
                        
                        Text("Monthly Reading Challenge")
                            .font(.headline)
                        
                        HStack {
                            Text("3 of 5 books completed")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("60%")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        ProgressView(value: 0.6)
                            .tint(.appAccent)
                        
                        Button(action: {
                            router.push(.challenges)
                        }) {
                            HStack {
                                Text("View Challenge")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .font(.subheadline.bold())
                            .foregroundColor(.appPrimary)
                            .padding()
                            .background(Color.appPrimary.opacity(0.08))
                            .cornerRadius(10)
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Continue Reading Section
                    Text("Continue Reading")
                        .font(.title3.bold())
                        .padding(.horizontal)
                    
                    Button(action: {
                        router.push(.bookDetails)
                    }) {
                        HStack(spacing: 16) {
                            // Book Cover Mock
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 60, height: 90)
                                .overlay(
                                    Image(systemName: "book.fill")
                                        .foregroundColor(.blue.opacity(0.5))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("The Midnight Odyssey")
                                    .font(.headline)
                                    .foregroundColor(.appTextPrimary)
                                Text("by Alistair Finch")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                HStack {
                                    Text("Chapter 14 • 4 mins left")
                                        .font(.caption2)
                                        .foregroundColor(.appAccent)
                                    Spacer()
                                    Text("64%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                    }
                    
                    // Discover Books (Horizontal Scroll)
                    HStack {
                        Text("Discover Books")
                            .font(.title3.bold())
                        Spacer()
                        Button("See All") {}
                            .font(.subheadline)
                            .foregroundColor(.appAccent)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            BookCoverMock(title: "Echoes of Clay", author: "Elena Rosas", color: .orange)
                            BookCoverMock(title: "Brewing Stars", author: "Nicolette Vance", color: .indigo)
                            BookCoverMock(title: "The Green Parlor", author: "K. Thorne", color: .green)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            // Handle routing
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .bookDetails:
                    BookDetailsView()
                case .updateProgress:
                    UpdateProgressView()
                case .challenges:
                    Text("Challenges View page")
                }
            }
        }
    }
}

// A small helper view to make the horizontal book list cleaner
struct BookCoverMock: View {
    let title: String
    let author: String
    let color: Color
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.2))
                .frame(width: 100, height: 150)
                .overlay(
                    Image(systemName: "book.closed.fill")
                        .font(.largeTitle)
                        .foregroundColor(color.opacity(0.6))
                )
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .lineLimit(1)
            Text(author)
                .font(.caption2)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 100)
        .onTapGesture {
            onTap?()
        }
    }
    
    #Preview {
        HomeView()
    }
}
