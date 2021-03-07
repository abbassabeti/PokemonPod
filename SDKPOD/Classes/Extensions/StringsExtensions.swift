//
//  StringsExtensions.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation

extension String {
    var url : URL? {
        get {
            return URL(string: self)
        }
    }
}

func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
