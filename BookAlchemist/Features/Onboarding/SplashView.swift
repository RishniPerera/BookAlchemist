//
//  SplashView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//
import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            // splash image
            Image("bookalchemitlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("Book Alchemist")
                .font(.system(size: 34, weight: .black))
                .foregroundColor(.appPrimary)
                .padding(.top, 20)
            
            Text("Read the story. Beat the challenge.")
                .font(.headline)
                .foregroundColor(.appTextPrimary)
                .padding(.top, 5)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            // Wait 2 seconds then move to onboarding
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}
