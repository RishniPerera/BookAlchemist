//
//  LoginView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Text("BOOK ALCHEMIST")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.appPrimary)
                    .padding(.bottom, 20)
                
                VStack(spacing: 10) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.appTextPrimary)
                    Text("Your reading challenge is waiting for you.")
                        .foregroundColor(.appTextSecondary)
                }
                
                // Face ID Box
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(red: 1.0, green: 0.95, blue: 0.90))
                        .frame(height: 220)
                    
                    Image(systemName: "faceid")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // face ID button
                VStack(spacing: 15) {
                    Button(action: handleFaceID) {
                        Text("Continue with Face ID")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .cornerRadius(25)
                    }
                    
                    //guest login button
                    Button(action: {
                        // Connect to Firebase anonymously
                        Task {
                            do {
                                _ = try await AuthService.shared.signInAsGuest()
                                // Switch to main app on the main thread
                                DispatchQueue.main.async {
                                    isLoggedIn = true
                                }
                            } catch {
                                errorMessage = "Failed to sign in: \(error.localizedDescription)"
                                showError = true
                            }
                        }
                    })
                    {
                        Text("Login as a guest")
                            .font(.headline)
                            .foregroundColor(.appTextPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.appPrimary.opacity(0.5), lineWidth: 1)
                            )
                    }
                    
                    // Email Login Button
                    NavigationLink(destination: EmailLoginView(isLoggedIn: $isLoggedIn)) {
                        Text("Log in with Email")
                            .font(.headline)
                            .foregroundColor(.appPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.appPrimary.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .alert("Authentication Failed", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }}
    
    private func handleFaceID() {
        FaceIDService.shared.authenticateUser { success, error in
            if success {
                isLoggedIn = true
            } else {
                errorMessage = error ?? "Unknown error"
                showError = true
            }
        }
    }
}
#Preview {
    LoginView(isLoggedIn: .constant(false))
}
