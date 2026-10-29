//
//  HomeView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @ObservedObject var router: AppRouter
    
    // Used @State variables instead of let constants
    @State private var userName: String = "Reader"
    @State private var userXp: Int = 0
    @State private var userLevel: Int = 1
    @State private var userStreak: Int = 0
    @State private var isLoading = true
    @State private var discoverBooks: [Book] = []
    @State private var isFlamePulsing = false
    @State private var isViewLoaded = false
    
   
        // A mock book for the Continue Reading section
        let currentReadingBook = Book(
            id: "mock_1",
            title: "The Midnight Odyssey",
            author: "Alistair Finch",
            coverURL: nil,
            totalPages: 300
        )
        
        // Computed properties for the progress bar
        var xpProgress: Double {
            GamificationService.shared.levelProgress(currentXp: userXp)
        }
        
        var xpToNextLevel: Int {
            GamificationService.shared.xpToNextLevel(currentXp: userXp)
        }
        
        var body: some View {
            NavigationStack(path: $router.path) {
                ZStack {
                    Color.appBackground.ignoresSafeArea()
                    
                    if isLoading {
                        ProgressView("Loading your library...")
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                
                                // Top Header
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("BOOK ALCHEMIST")
                                            .font(.custom("Avenir-Black", size: 14))
                                            .foregroundColor(.appPrimary)
                                            .tracking(1.5)
                                        
                                        Text("Hello, \(userName)")
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .foregroundColor(.appTextPrimary)
                                    }
                                    
                                    Spacer()
                                    
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
                                        
                                        // Streak Flame
                                        HStack(spacing: 4) {
                                            Image(systemName: "flame.fill")
                                                .foregroundColor(.appAccent)
                                                .scaleEffect(isFlamePulsing ? 1.2 : 1.0)
                                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isFlamePulsing)
                                            Text("\(userStreak) Day Streak")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.appAccent.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                        // XP Badge
                                        HStack(spacing: 4) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                            Text("\(userXp) XP")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.yellow.opacity(0.15))
                                        .cornerRadius(10)
                                    }
                                    
                                    HStack {
                                        Text("Level \(userLevel)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("\(Int(xpProgress * 100))% completed")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    // Custom Progress Bar
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 8)
                                                .foregroundColor(Color.red.opacity(0.4))
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(width: isViewLoaded ? geo.size.width * max(0.01, xpProgress) : 0, height: 8)
                                                .foregroundColor(.appPrimary)
                                                .animation(.easeOut(duration: 1.5), value: xpProgress)
                                        }
                                    }
                                    .frame(height: 8)
                                    
                                    Text("\(xpToNextLevel) XP to Level \(userLevel + 1)")
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
                                    
                                    
                                    NavigationLink(destination: ChallengesView()) {
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
                                
                               
                                NavigationLink(destination: ReaderView(book: currentReadingBook)) {
                                    HStack(spacing: 16) {
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
                                
                                // Discover Books
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
                                        if discoverBooks.isEmpty {
                                            ForEach(0..<3) { _ in
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.gray.opacity(0.1))
                                                    .frame(width: 100, height: 150)
                                            }
                                        } else {
                                            ForEach(discoverBooks) { book in
                                                NavigationLink(destination: BookDetailsView(book: book)) {
                                                    VStack(alignment: .leading, spacing: 8) {
                                                        if let cover = book.coverURL, let url = URL(string: cover) {
                                                            AsyncImage(url: url) { image in
                                                                image.resizable().scaledToFill()
                                                            } placeholder: {
                                                                ProgressView()
                                                            }
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(8)
                                                            .clipped()
                                                        } else {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.gray.opacity(0.3))
                                                                .frame(width: 100, height: 150)
                                                        }
                                                        
                                                        Text(book.title)
                                                            .font(.caption)
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.appTextPrimary)
                                                            .lineLimit(1)
                                                        Text(book.author)
                                                            .font(.caption2)
                                                            .foregroundColor(.gray)
                                                            .lineLimit(1)
                                                    }
                                                    .frame(width: 100)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                
                                Spacer(minLength: 40)
                            }
                            .padding(.top, 20)
                            .frame(maxWidth: 600)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .navigationBarHidden(true)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .bookDetails:
                        BookDetailsView(book: currentReadingBook)
                    case .updateProgress:
                        UpdateProgressView()
                    case .challenges:
                        ChallengesView()
                    case .reader(let book):
                        ReaderView(book: book)
                    }
                }
                .onAppear {
                    listenForUserUpdates()
                    // force a one-time fetch just in case the listener fell asleep
                        Task {
                            if let userId = AuthService.shared.currentUserId {
                                if let profile = try? await FirestoreService.shared.fetchUserProfile(userId: userId) {
                                    await MainActor.run {
                                        self.userXp = profile.xp
                                        self.userLevel = profile.currentLevel
                                        self.userStreak = profile.readingStreak
                                    }
                                }
                            }
                        }
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFlamePulsing = true
                        isViewLoaded = true
                    }}
                .task {
                    if discoverBooks.isEmpty {
                        do {
                            discoverBooks = try await BookAPIService.shared.fetchDiscoverBooks()
                        } catch {
                            print("Failed to load discover books: \(error)")
                        }
                    }
                }
            }
        }
        
        private func listenForUserUpdates() {
            guard let userId = AuthService.shared.currentUserId else {
                isLoading = false
                return
            }
            
            Firestore.firestore(database: "default").collection("users").document(userId)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot, document.exists else {
                        isLoading = false
                        return
                    }
                    
                    do {
                        let profile = try document.data(as: UserProfile.self)
                        DispatchQueue.main.async {
                            self.userName = profile.name
                            self.userXp = profile.xp
                            self.userLevel = profile.currentLevel
                            self.userStreak = profile.readingStreak
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding user: \(error)")
                        isLoading = false
                    }
                }
        }
    }

    #Preview {
        HomeView(router: AppRouter())
    }
