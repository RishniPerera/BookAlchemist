//
//  EmailLoginView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-29.
//

import SwiftUI

struct EmailLoginView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isLoggedIn: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Create Account" : "Welcome Reader")
                .font(.largeTitle.bold())
                .foregroundColor(.appTextPrimary)
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: handleAuth) {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(isSignUp ? "Sign Up" : "Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.appPrimary)
            .cornerRadius(16)
            .disabled(email.isEmpty || password.isEmpty || isLoading)
            
            Button(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                isSignUp.toggle()
                errorMessage = ""
            }
            .font(.subheadline)
            .foregroundColor(.appPrimary)
            
            Spacer()
        }
        .padding(30)
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
    }
    
    private func handleAuth() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                if isSignUp {
                    _ = try await AuthService.shared.signUpWithEmail(email: email, password: password)
                } else {
                    _ = try await AuthService.shared.signInWithEmail(email: email, password: password)
                }
                
                DispatchQueue.main.async {
                    isLoading = false
                    isLoggedIn = true // Go to MainTabView
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
