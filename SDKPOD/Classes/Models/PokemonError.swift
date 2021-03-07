//
//  PokemonError.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation

public struct PokemonError: Codable {

    var code: Int?
    var message: String?

    init(code: Int?,message: String?) {
        self.code = code
        self.message = message
    }
    
    init(unexpected: Bool){
        self.code = -1
        self.message = "Unexpected Error"
    }
}

extension PokemonError: Error{
    
}
