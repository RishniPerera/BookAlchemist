//
//  BookAlchemistApp.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
       // Request notification permission on startup
        NotificationService.shared.requestPermission()
        return true
    }
}

@main
struct BookAlchemistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Track onboarding completion (saves to device memory)
        @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    // Using AppStorage to track if the user has seen onboarding
      // Default is false for new users
    @State var isLoggedIn: Bool = false
    
    // Track splash screen state
        @State private var isSplashActive: Bool = true

    
    var body: some Scene {
        WindowGroup {
            // navigation logic
                       ZStack {
                           if isSplashActive {
                               SplashView(isActive: $isSplashActive)
                                   .transition(.opacity)
                           } else {
                               if isLoggedIn {
                                   // If logged in, show the main app
                                   MainTabView(isLoggedIn: .constant(true))
                               } else if hasSeenOnboarding {
                                   // If not logged in, but saw onboarding, show Login
                                   LoginView(isLoggedIn: $isLoggedIn)
                               } else {
                                   // Brand new user, show Onboarding first
                                   OnboardingView(isOnboarded: $hasSeenOnboarding)
                               }
                    }
            }
        }
    }
}
