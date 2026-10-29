//  Created by Student 1 on 2026-10-17.

import Foundation

struct Book: Identifiable, Codable, Hashable {
    // If the API doesn't give an ID, generate one
    var id: String = UUID().uuidString
    var title: String
    var author: String
    var coverURL: String? // Used for AsyncImage from the API
    var totalPages: Int
    
    // description field to simulate reading pages
        var description: String?
    // These are for the user's personal library
    var currentPage: Int = 0
    var status: String = "Want to Read"
    
    // This calculates the progress bar
    var progressPercentage: Int {
        guard totalPages > 0 else { return 0 }
        return Int((Double(currentPage) / Double(totalPages)) * 100)
    }
}
