//
//  CommunityView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct CommunityView: View {
// State variables for Firebase data and Create Post sheet
        @State private var posts: [CommunityPost] = []
        @State private var showCreatePost = false
        
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
                                
                                // Changed the bell to a "+" button to create a post
                                Button(action: { showCreatePost = true }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.appPrimary)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            // Featured Challenge Banner (Kept as is)
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
                            
                            // Load Real Posts from Firebase
                            if posts.isEmpty {
                                Text("No posts yet. Be the first to share!")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(posts) { post in
                                    postCard(post: post)
                                }
                            }
                            
                            Spacer(minLength: 40)
                        }
                    }
                }
                // Present the Create Post View
                .sheet(isPresented: $showCreatePost, onDismiss: {
                    loadPosts()
                                  }) {
                    CreatePostView()
                }
                // Fetch posts when the view appears
                .task {
                    loadPosts()
                }
            }
        }
   
        // Fetch Function
        private func loadPosts() {
            Task {
                if let fetchedPosts = try? await FirestoreService.shared.fetchPosts() {
                    DispatchQueue.main.async {
                        self.posts = fetchedPosts
                    }
                }
            }
        }
        
        // Updated Helper Function to accept CommunityPost
        private func postCard(post: CommunityPost) -> some View {
            VStack(alignment: .leading, spacing: 12) {
                // User Info Header
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(post.authorName)
                            .font(.headline)
                        // Automatically shows "2 hours ago", "Just now", etc.
                        Text(post.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Keeping a static badge for UI consistency based on Figma
                    Text("New Post")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                }
                
                // Post Content
                Text(post.content)
                    .font(.subheadline)
                    .lineSpacing(4)
                
                Divider()
                
                // Bottom Actions
                HStack(spacing: 20) {
                    Label("0", systemImage: "heart")
                    Label("0", systemImage: "bubble.left")
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
