//
//  Configs.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation

struct Configs {

    struct App {
        static let githubUrl = "To be added"
        static let bundleIdentifier = "com.abbas.Pokemon"
    }

    struct Network {
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = false
        static let pokemonBaseUrl = "https://pokeapi.co"
        static let shakespeare = "https://api.funtranslations.com"
    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }

    struct UserDefaultsKeys {
        static let bannersEnabled = "BannersEnabled"
    }
}
