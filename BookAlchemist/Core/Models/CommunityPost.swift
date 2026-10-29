//
//  CommunityPost.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-27.
//

import Foundation

struct CommunityPost: Identifiable, Codable {
    var id: String = UUID().uuidString
    var authorName: String
    var authorId: String
    var content: String
    var timestamp: Date
}
