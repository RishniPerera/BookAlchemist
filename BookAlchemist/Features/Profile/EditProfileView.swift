//
//  EditProfileView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-29.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var newName: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Profile Picture Picker
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.appPrimary, lineWidth: 3))
                    } else {
                        Circle()
                            .fill(Color.appPrimary.opacity(0.15))
                            .frame(width: 120, height: 120)
                            .overlay(
                                VStack {
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .foregroundColor(.appPrimary)
                                    Text("Add Photo")
                                        .font(.caption)
                                        .foregroundColor(.appPrimary)
                                }
                            )
                    }
                }
                .onChange(of: selectedItem) { oldValue, newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display Name")
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    
                    TextField("Enter your name", text: $newName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                }
                
                Spacer()
                
                // Save Button
                Button(action: saveProfile) {
                    if isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.appPrimary)
                .cornerRadius(16)
                .disabled(isSaving)
            }
            .padding(30)
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                // Load current name if it exists
                if let currentName = UserDefaults.standard.string(forKey: "userDisplayName") {
                    newName = currentName
                }
                // Load current profile picture if it exists
                if let data = UserDefaults.standard.data(forKey: "userProfilePicture") {
                    selectedImageData = data
                }
            }
        }
    }
    
    private func saveProfile() {
        isSaving = true
        
        // Save name and picture locally on device
        UserDefaults.standard.set(newName, forKey: "userDisplayName")
        if let data = selectedImageData {
            UserDefaults.standard.set(data, forKey: "userProfilePicture")
        }
        
        // Update the name in Firebase as well as optional
        if let userId = AuthService.shared.currentUserId {
            Task {
                do {
                    let userRef = FirestoreService.shared
                    DispatchQueue.main.async {
                        isSaving = false
                        dismiss()
                    }
                }
            }
        } else {
            isSaving = false
            dismiss()
        }
    }
}
