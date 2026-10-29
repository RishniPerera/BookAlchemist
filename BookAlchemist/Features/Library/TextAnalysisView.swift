//
//  TextAnalysisView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-29.
//

import SwiftUI

struct TextAnalysisView: View {
    let entities: NaturalLanguageService.TextEntities
    @Environment(\.dismiss) var dismiss
    
    // State to simulate the ML processing time
    @State private var isAnalyzing = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if isAnalyzing {
                    // Loading State
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.appPrimary)
                        Text("Running on-device NLP analysis...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    // Results State
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            Text("Apple's Natural Language framework scanned this passage and identified the following entities:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            // People
                            if !entities.people.isEmpty {
                                entitySection(title: "People", icon: "person.2.fill", items: entities.people, color: .blue)
                            }
                            
                            // Places
                            if !entities.places.isEmpty {
                                entitySection(title: "Places", icon: "map.fill", items: entities.places, color: .green)
                            }
                            
                            // Organizations
                            if !entities.organizations.isEmpty {
                                entitySection(title: "Organizations", icon: "building.2.fill", items: entities.organizations, color: .purple)
                            }
                            
                            if entities.people.isEmpty && entities.places.isEmpty && entities.organizations.isEmpty {
                                Text("No specific names, places, or organizations were found on this page.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationTitle("Smart Text Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                // Simulate a 1-second delay to see the "Advanced ML" working
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        isAnalyzing = false
                    }
                }
            }
        }
    }
    
    // Helper Functions
    
    private func entitySection(title: String, icon: String, items: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            // Display items as pills
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .leading, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.subheadline.bold())
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(color.opacity(0.1))
                        .foregroundColor(color)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5)
        .padding(.horizontal)
    }
}
