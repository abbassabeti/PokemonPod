//
//  ErrorResponse.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//


import Foundation

private struct ErrorResponse: Codable {
    var message: String?
    var errors: [ErrorModel] = []
    var documentationUrl: String?

    init() {}

    func detail() -> String {
        return errors.map { $0.message ?? "" }
            .joined(separator: "\n")
    }
}

private struct ErrorModel: Codable{
    var code: String?
    var message: String?
    var field: String?
    var resource: String?

    init() {}
}
