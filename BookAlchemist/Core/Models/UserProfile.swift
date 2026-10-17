//
//  UserProfile.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-17.

import Foundation

struct UserProfile: Codable {
    var uid: String
    var name: String
    var email: String
    var currentLevel: Int = 1
    var xp: Int = 0
    var readingStreak: Int = 0
}
