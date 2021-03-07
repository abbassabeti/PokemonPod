//
//  Pokemon.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation

// MARK: - Pokemon
struct Species: Codable {
    let flavorTextEntries: [FlavorTextEntry]
    let name: String
    let order: Int

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
        case name
        case order
    }
}

// MARK: - FlavorTextEntry
struct FlavorTextEntry: Codable {
    let flavorText: String

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
    }
}

