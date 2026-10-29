import SwiftUI
import FirebaseAuth

struct ChallengeDetailsView: View {
    var challenge: Challenge
    
    @Environment(\.dismiss) var dismiss
    @State private var isJoining = false
    @State private var hasJoined = false
    
    // Animation States
    @State private var isTrophyBouncing = false
    @State private var showRewardCard = false
    @State private var showRulesCard = false
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Top Banner with Trophy
                VStack(spacing: 16) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                        // The bounce animation
                        .scaleEffect(isTrophyBouncing ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isTrophyBouncing)
                    
                    Text(challenge.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: 0.0)
                            .stroke(Color.appAccent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 2) {
                            Text("0/\(challenge.targetBooks)")
                                .font(.headline)
                            Text("completed")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 30)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color(red: 0.9, green: 0.9, blue: 0.7), Color(red: 0.8, green: 0.85, blue: 0.6)], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Reward Banner
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.yellow)
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    VStack(alignment: .leading) {
                        Text("ACTIVE REWARD")
                            .font(.caption2.bold())
                            .foregroundColor(.appAccent)
                        Text("Unlock \(challenge.xpReward) XP Achievement")
                            .font(.subheadline.bold())
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.03), radius: 5)
                .padding(.horizontal)
                // Slide in modifiers
                .offset(y: showRewardCard ? 0 : 30)
                .opacity(showRewardCard ? 1 : 0)
                
                // Challenge Rules
                VStack(alignment: .leading, spacing: 12) {
                    Text("Challenge Rules")
                        .font(.headline)
                    
                    ruleRow(text: "Read and log \(challenge.targetBooks) books within the calendar month")
                    ruleRow(text: "Any genre counts toward the goal")
                    ruleRow(text: "Earn \(challenge.xpReward) XP upon completion")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                // Slide in modifiers
                .offset(y: showRulesCard ? 0 : 30)
                .opacity(showRulesCard ? 1 : 0)
                
                Spacer(minLength: 20)
                
                // Action Button
                Button(action: {
                    // Bounce button down
                    withAnimation(.easeInOut(duration: 0.1)) {
                        buttonScale = 0.92
                    }
                    // Bounce it back up
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            buttonScale = 1.0
                        }
                    }
                    
                    joinChallenge()
                }) {
                    if isJoining {
                        ProgressView().tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.appPrimary)
                            .cornerRadius(16)
                    } else {
                        Text(hasJoined ? "Challenge Started! " : "Start Challenge")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasJoined ? Color.green : Color.appPrimary)
                            .cornerRadius(16)
                            .shadow(color: hasJoined ? Color.green.opacity(0.4) : Color.appPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .disabled(hasJoined || isJoining)
                .scaleEffect(buttonScale)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .padding(.top)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Challenge Details")
        .navigationBarTitleDisplayMode(.inline)
        // Delayed OnAppear
        .onAppear {
            //  Start trophy bounce
            isTrophyBouncing = true
            
            // Wait 0.1 seconds for view to render, then animate cards in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.6)) {
                    showRewardCard = true
                }
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    showRulesCard = true
                }
            }
        }
    }
    
    private func ruleRow(text: String) -> some View {
        HStack(alignment: .top) {
            Circle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private func joinChallenge() {
        guard let userId = AuthService.shared.currentUserId else { return }
        isJoining = true
        
        Task {
            do {
                try await FirestoreService.shared.joinChallenge(userId: userId, challenge: challenge)
                DispatchQueue.main.async {
                    // Animate the button turning green
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        isJoining = false
                        hasJoined = true
                    }
                }
            } catch {
                print("Error joining challenge: \(error)")
                isJoining = false
            }
        }
    }
}

#Preview {
    NavigationStack {

        ChallengeDetailsView(challenge: Challenge(title: "Mystery Month", description: "Read 3 mystery novels", xpReward: 175, targetBooks: 3))
    }
}
