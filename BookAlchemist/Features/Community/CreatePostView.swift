//
//  CreatePostView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-27.
//

import SwiftUI
import FirebaseAuth

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postText = ""
    @State private var isPosting = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $postText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5)
                    .padding()
                    .overlay(
                        Text(postText.isEmpty ? "What are you reading today?" : "")
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(25),
                        alignment: .topLeading
                    )
                
                Button(action: submitPost) {
                    if isPosting {
                        ProgressView().tint(.white)
                    } else {
                        Text("Share with Community")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appPrimary)
                .cornerRadius(16)
                .padding()
                .disabled(postText.isEmpty || isPosting)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func submitPost() {
        guard let userId = AuthService.shared.currentUserId else { return }
        isPosting = true
        Task {
            var authorName = "Reader" // Default fallback
            do {
                // Try to get the profile from Firestore
                let profile = try? await FirestoreService.shared.fetchUserProfile(userId: userId)
                
                // Safely unwrap the optional profile
                if let unwrappedProfile = profile {
                    authorName = unwrappedProfile.name
                }
            } catch {
                // If Firestore fails, print the error
                print("DEBUG: Failed to fetch profile: \(error)")
                
                // Fallback: Get the email directly from Firebase Auth
                if let email = Auth.auth().currentUser?.email, !email.isEmpty {
                    authorName = email.components(separatedBy: "@").first ?? "Reader"
                }
            }
            
            do {
                // 5. Save the post
                try await FirestoreService.shared.savePost(
                    userId: userId,
                    name: authorName,
                    content: postText
                )
                
                DispatchQueue.main.async {
                    isPosting = false
                    dismiss()
                }
            } catch {
                print("Error posting: \(error)")
                isPosting = false
            }
        }
    }
}
            
        
