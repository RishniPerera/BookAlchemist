//
//  ReaderView.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-27.
//

import SwiftUI

struct ReaderView: View {
    var book: Book
    
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    @State private var isFinishing = false
    @State private var showSuccessAlert = false
    
    // for Natural Language SDK feature
    @State private var analysisResult: NaturalLanguageService.TextEntities?
    @State private var showAnalysis = false
    
    // Track the text the user highlights
       @State private var selectedText: String = ""
   
    // 5 pages of text of the selected book
    var pages: [String] {
        let baseText = book.title + "\n\n" + (book.description ?? "Once upon a time, there was a reader who loved to read. They opened this book and found a world of wonder.")
        
        // repeating text to ensure the book is long enough to have multiple pages
        let filler = String(repeating: "The story continues. Every page brings a new adventure. The characters travel through mystical lands, discovering ancient secrets and forging unbreakable bonds. ", count: 15)
        
        let fullText = baseText + "\n\n" + filler
        
        // Split the text into chunks of 500 characters to fit to the screen
        return stride(from: 0, to: fullText.count, by: 500).map { index in
            let start = fullText.index(fullText.startIndex, offsetBy: index)
            let end = fullText.index(start, offsetBy: min(500, fullText.count - index))
            return String(fullText[start..<end])
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.appTextPrimary)
                        .padding()
                }
                Spacer()
                Text(book.title)
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                Spacer()
                
                // button to detect natural languages
                                Button(action: {
                                    analyzeCurrentPage()
                                }) {
                                    Image(systemName: "text.magnifyingglass")
                                        .foregroundColor(.appPrimary)
                                        .padding(.horizontal, 8)
                                }
            
                // Page Counter
                Text("Page \(currentPage + 1) of \(pages.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 3, y: 3)
            
            // The actual reading text
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    ScrollView {
                        // REPLACED Text with the custom SelectableTextView
                            SelectableTextView(text: pages[index], selectedText: $selectedText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(30)
                                            }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color(red: 0.98, green: 0.96, blue: 0.92)) // Book paper color
            .onChange(of: currentPage) { oldValue, newValue in
                           selectedText = ""
                       }
                       
            
            // Bottom Navigation / Finish Button
            HStack {
                // Left Arrow
                Button(action: {
                    withAnimation { currentPage = max(0, currentPage - 1) }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                        .foregroundColor(currentPage == 0 ? .gray.opacity(0.3) : .appPrimary)
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                // Show Finish Button only on the last page
                if currentPage == pages.count - 1 {
                    Button(action: finishBook) {
                        if isFinishing {
                            ProgressView().tint(.white)
                        } else {
                            Text("Finish Book ")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.appAccent)
                    .cornerRadius(20)
                    .shadow(color: .appAccent.opacity(0.4), radius: 5, y: 3)
                } else {
                    Text("Swipe or tap arrows to read")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Right Arrow
                Button(action: {
                    withAnimation { currentPage = min(pages.count - 1, currentPage + 1) }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .padding()
                        .foregroundColor(currentPage == pages.count - 1 ? .gray.opacity(0.3) : .appPrimary)
                }
                .disabled(currentPage == pages.count - 1)
            }
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: .black.opacity(0.05), radius: 5, y: -5)
        }
        .navigationBarHidden(true)
        .alert("Book Completed!", isPresented: $showSuccessAlert) {
            Button("Awesome!") { dismiss() }
        } message: {
            Text("You earned 100 XP and increased your reading streak. Check your profile!")
        }
        // Present the Text Analysis Sheet
                .sheet(isPresented: $showAnalysis) {
                    if let result = analysisResult {
                        TextAnalysisView(entities: result)
                    }
                }
    }
    
    // The function that triggers the Natural Language processing
        private func analyzeCurrentPage() {
            guard currentPage < pages.count else { return }
      
            // Use the selected text if user highlighted something, otherwise use the whole page
                    let textToAnalyze = selectedText.isEmpty ? pages[currentPage] : selectedText
            
            // Pass it to our Natural Language Service
            let result = NaturalLanguageService.shared.analyzeText(textToAnalyze)
            
            // Save the result and trigger the sheet to open
            analysisResult = result
            showAnalysis = true
        }
    
    private func finishBook() {
        guard let userId = AuthService.shared.currentUserId else { return }
        isFinishing = true
        
        Task {
            do {
                // Fetch current profile to get existing XP
                let profile = try await FirestoreService.shared.fetchUserProfile(userId: userId)
                
                // Complete the book and update Firebase
                _ = try await FirestoreService.shared.completeBook(userId: userId, book: book, currentProfile: profile)
                
                DispatchQueue.main.async {
                    isFinishing = false
                    showSuccessAlert = true
                }
            } catch {
                print("Error finishing book: \(error)")
                isFinishing = false
            }
        }
    }
}
// UITextView Wrapper for Layout & Selection
struct SelectableTextView: UIViewRepresentable {
    var text: String
    @Binding var selectedText: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.widthTracksTextView = true
        textView.textContainer.lineFragmentPadding = 0
        
     
        let bookFont = UIFont(name: "Georgia", size: 20) ?? UIFont.systemFont(ofSize: 20)
        textView.font = bookFont
        textView.textColor = UIColor(Color.appTextPrimary)
        
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Create paragraph style for justification and line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineSpacing = 8 // Nice breathing room between lines
        
        // Use the exact same font as makeUIView
        let bookFont = UIFont(name: "Georgia", size: 20) ?? UIFont.systemFont(ofSize: 20)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: bookFont,
            .foregroundColor: UIColor(Color.appTextPrimary)
        ]
        
        // Apply as an attributed string
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedText: $selectedText)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIScreen.main.bounds.width
        let size = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return CGSize(width: width, height: size.height)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var selectedText: Binding<String>
        
        init(selectedText: Binding<String>) {
            self.selectedText = selectedText
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if let range = textView.selectedTextRange, !range.isEmpty {
                selectedText.wrappedValue = textView.text(in: range) ?? ""
            } else {
                selectedText.wrappedValue = ""
            }
        }
    }
}
