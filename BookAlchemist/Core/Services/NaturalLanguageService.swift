//
//  NaturalLanguageService.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-29.
//

import Foundation
import NaturalLanguage

class NaturalLanguageService {
    static let shared = NaturalLanguageService()
    
    // A simple struct to hold our results
    struct TextEntities {
        var people: [String] = []
        var places: [String] = []
        var organizations: [String] = []
    }
    
    // Analyzes the text and returns the extracted entities
    func analyzeText(_ text: String) -> TextEntities {
        var entities = TextEntities()
        
        // Setup the tagger for Names, Places, and Orgs
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        
        // Define the options (ignore punctuation, whitespace, and limit to names/places/orgs)
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NLTag] = [.personalName, .placeName, .organizationName]
        
        // Iterate through the text to find matches
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            
            // Ensure that found a valid tag
            guard let tag = tag, tags.contains(tag) else { return true }
            
            // Extract the actual word from the text
            let entityName = String(text[tokenRange])
            
            // Sort into arrays and avoid duplicates
            switch tag {
            case .personalName:
                if !entities.people.contains(entityName) { entities.people.append(entityName) }
            case .placeName:
                if !entities.places.contains(entityName) { entities.places.append(entityName) }
            case .organizationName:
                if !entities.organizations.contains(entityName) { entities.organizations.append(entityName) }
            default:
                break
            }
            
            return true
        }
        
        return entities
    }
}
