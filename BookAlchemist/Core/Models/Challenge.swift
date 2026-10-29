//
//  Challenge.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-27.
//
import Foundation

struct Challenge: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var xpReward: Int
    var targetBooks: Int
    var isJoined: Bool = false
    var booksCompleted: Int = 0
}
