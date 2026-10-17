//
//  OnboardingView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//
import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarded: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Onboarding Image
            Image("bookwithstars")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
            
            Text("Read the story, Beat the challenge.")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Discover books, build your reading habit, complete challenges, earn achievements and connect with other readers.")
                .multilineTextAlignment(.center)
                .foregroundColor(.appTextSecondary)
                .padding(.horizontal, 30)
            
            Spacer()
            
            // splash screens for onboarding
            HStack(spacing: 8) {
                Capsule().fill(Color.appPrimary).frame(width: 20, height: 8)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                Circle().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
            }
            .padding(.bottom, 20)
            
            Button(action: {
                isOnboarded = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 30)
            
            Button("Skip") {
                isOnboarded = true
            }
            .foregroundColor(.appTextSecondary)
            .padding(.bottom, 30)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}
