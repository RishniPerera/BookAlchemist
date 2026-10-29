//
//  SplashView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//
import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    
    // Animation states
        @State private var logoScale: CGFloat = 0.5
        @State private var logoOpacity: Double = 0.0
        @State private var glowOpacity: Double = 0.0
 
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo with Glow
                ZStack {
                    // The magical glow behind the logo
                    Circle()
                        .fill(Color.appPrimary.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .blur(radius: 40)
                        .opacity(glowOpacity)
                    Image("bookalchemitlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                Text("Book Alchemist")
                    .font(.system(size: 34, weight: .black, design: .serif))
                    .foregroundColor(.appPrimary)
                    .opacity(logoOpacity)
                
                
                Text("Read the story. Beat the challenge.")
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)
                    .opacity(logoOpacity)
            }}
        .onAppear {
                   // Animate the logo popping in
                   withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                       logoScale = 1.0
                       logoOpacity = 1.0
                   }
                   
                   // Animate the glow pulsing
                   withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                       glowOpacity = 1.0
                   }
                   
                   // Wait 3 seconds, then transition to the app
                   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                       withAnimation(.easeOut(duration: 0.5)) {
                           isActive = false
                }
            }
        }
    }
}
