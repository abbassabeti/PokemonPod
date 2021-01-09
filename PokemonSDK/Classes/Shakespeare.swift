//
//  Shakespeare.swift
//  PokemonSDK
//
//  Created by Abbas on 1/7/21.
//

import Foundation

// MARK: - Shakespeare
public struct Shakespeare: Codable {
    let success: Success
    public let contents: Contents
}

// MARK: - Contents
public struct Contents: Codable {
    public let translated: String
    let text, translation: String
}

// MARK: - Success
struct Success: Codable {
    let total: Int
}
