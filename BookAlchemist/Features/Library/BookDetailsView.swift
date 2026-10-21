//
//  BookDetailsView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI

struct BookDetailsView: View {
    @State private var selectedStatus: String = "Want to Read"
    let statuses = ["Want to Read", "Reading", "Completed"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Book Cover Large
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.7, green: 0.5, blue: 0.3))
                    .frame(width: 160, height: 240)
                    .overlay(
                        VStack {
                            Text("THE LAST ORACLE")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Image(systemName: "sun.max.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                            Spacer()
                        }
                        .padding()
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 10)
                
                // Title & Author
                VStack(spacing: 8) {
                    Text("The Last Oracle")
                        .font(.title.bold())
                    Text("by Helena Rostova")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Text("2024 • 412 pages • Fiction")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                        Text("4.5 (1240 ratings)")
                            .font(.caption)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                // Add to Library Button
                Button(action: {}) {
                    Text("+ Add to Library")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                
        // Add a "Start Reading" Button for navigation demo
        NavigationLink(destination: UpdateProgressView()) {
        Text("Start Reading Now")
        .font(.headline)
        .foregroundColor(.appPrimary)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
        RoundedRectangle(cornerRadius: 16)
        .stroke(Color.appPrimary.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                .padding(.horizontal)
                
                // Reading Status Segmented Control
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reading Status")
                        .font(.headline)
                    
                    HStack(spacing: 0) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedStatus == status ? Color.appPrimary : Color.white)
                                .foregroundColor(selectedStatus == status ? .white : .gray)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // About this book
                VStack(alignment: .leading, spacing: 8) {
                    Text("About this Book")
                        .font(.headline)
                    Text("At the edge of the Mediterranean, the lost library contains every secret never spoken. When Clara uncovers a brass astrolabe hidden in the dust, she unwittingly awakens a modern-day oracle. A breathtaking tale of fate, cosmic balance, and the preservation of forgotten memories.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Rating Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Rating")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.appAccent)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Add Note Section
                Button(action: {}) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Add Personal Note")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                    .foregroundColor(.appTextPrimary)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top)
        }
        .navigationTitle("Book Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        BookDetailsView()
    }
}

