//  Created by Student 1 on 2026-10-17.

import Foundation

struct Book: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var author: String
    var coverImageName: String
    var totalPages: Int
    var currentPage: Int = 0
    var status: ReadingStatus = .wantToRead
    
    enum ReadingStatus: String, Codable, CaseIterable {
        case wantToRead = "Want to Read"
        case reading = "Reading"
        case completed = "Completed"
    }
    
    var progressPercentage: Int {
        guard totalPages > 0 else { return 0 }
        return Int((Double(currentPage) / Double(totalPages)) * 100)
    }
}
