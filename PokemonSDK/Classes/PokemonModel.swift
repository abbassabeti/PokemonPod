//
//  Pokemon.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation

// MARK: - Pokemon
public class PokemonModel: NSObject, Codable {
    var id: Int
    var name: String
    var order: Int?
    var species: SpeciesReference?
    var sprites: Sprites
    var isFavorite : Bool = false
    public var shakespeare : Shakespeare?

    enum CodingKeys: String, CodingKey {
        case id
        case name, order, species, sprites
    }
    
    public func getSpritesList() -> [(Int,URL)]{
        return [sprites.frontDefault,sprites.backDefault,sprites.frontShiny,sprites.backShiny].compactMap({URL(string: $0)}).map({(id,$0)})
    }
    
    public init(id: Int,name: String,sprites:[String],translation: String) {
        self.id = id
        self.name = name
        self.sprites = Sprites(items: sprites)
        self.shakespeare = Shakespeare(success: Success(total: 1), contents: Contents(translated: translation, text: "", translation: ""))
        super.init()
    }
}

// MARK: - Species
struct SpeciesReference: Codable {
    let name: String
    let url: String
}

// MARK: - Sprites
public class Sprites: Codable {
    public let backDefault: String
    public let frontDefault: String
    public let backShiny: String
    public let frontShiny: String

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case frontDefault = "front_default"
        case backShiny = "back_shiny"
        case frontShiny = "front_shiny"
    }

    init(backDefault: String, frontDefault: String,backShiny: String, frontShiny: String) {
        self.backDefault = backDefault
        self.frontDefault = frontDefault
        self.backShiny = backShiny
        self.frontShiny = frontShiny
    }
    init(items: [String]) {
        self.frontDefault = items.count > 0 ? items[0] : ""
        self.backDefault = items.count > 1 ? items[1] : ""
        self.frontShiny = items.count > 2 ? items[2] : ""
        self.backShiny = items.count > 3 ? items[3] : ""
    }
}


