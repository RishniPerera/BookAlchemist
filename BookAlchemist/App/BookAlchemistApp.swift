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
        return true
    }
}

@main
struct BookAlchemistApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Using AppStorage to track if the user has seen onboarding
      // Default is false for new users
    @State private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
               
                Text("Splash / Onboarding goes here")
                    .onAppear {
                        // isLoggedIn = true
                    }
            }
        }
    }
}
