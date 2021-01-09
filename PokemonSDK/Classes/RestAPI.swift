//
//  RestAPI.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//


import Foundation
import RxSwift
import Moya
import Alamofire

typealias MoyaError = Moya.MoyaError

enum ApiError: Error {
    case serverError(response: PokemonError)
}

class RestApi: PokemonAPIProtocol {
    let pokemonProvider: PokemonNetworking
    let decoder : JSONDecoder = JSONDecoder()

    init(pokemonProvider: PokemonNetworking) {
        self.pokemonProvider = pokemonProvider
    }
}

extension RestApi {

    func downloadString(url: URL) -> Single<String> {
        return Single.create { single in
            DispatchQueue.global().async {
                do {
                    single(.success(try String.init(contentsOf: url)))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create { }
            }
            .observeOn(MainScheduler.instance)
    }
    func getPokemon(name: String) -> Single<Result<PokemonModel,PokemonError>> {
        return requestObject(.findPokemon(name: name), type: PokemonModel.self)
    }
    func getSpecies(name: String) -> Single<Result<Species,PokemonError>> {
        return requestObject(.findSpecies(name: name), type: Species.self)
    }
    func getSpecies(url: String) -> Single<Result<Species,PokemonError>> {
        return requestObject(.findSpeciesByURL(url: url), type: Species.self)
    }
    
    func getShakespeare(text: String) -> Single<Result<Shakespeare,PokemonError>> {
        return requestObject(.translateShakespeare(text: text), type: Shakespeare.self)
    }
}
extension RestApi {
    private func request(_ target: PokemonAPI) -> Single<Any> {
        return pokemonProvider.request(target)
            .mapJSON()
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
    
    private func requestWithoutMapping(_ target: PokemonAPI) -> Single<Moya.Response> {
        return pokemonProvider.request(target)
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
    
    private func requestObject<T: Codable>(_ target: PokemonAPI,type: T.Type) -> Single<Result<T, PokemonError>> {
        return pokemonProvider.request(target)
            .debug("log", trimOutput: false).map({ (response) -> Result<T, PokemonError> in
                do {
                    switch response.statusCode {
                        case 200...204:
                            return try .success(self.decoder.decode(T.self,from:response.data))
                        case 429:
                            return .failure(PokemonError(code: 429, message: "Shakespeare Ratelimit reached!"))
                        case 500...:
                            return .failure(PokemonError(code: 400, message: "Internal Server Error"))
                        default:
                            guard let pokemonError = try? self.decoder.decode(PokemonError.self,from:response.data) else {
                                return .failure(PokemonError(unexpected: true))
                            }
                            var error = pokemonError
                            error.code = response.statusCode
                            return .failure(error)
                            
                    }
                }catch let error{
                        return .failure(PokemonError(code: response.statusCode, message: error.localizedDescription))
                }

            })
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
    
    private func requestArray<T:Codable>(_ target: PokemonAPI, type: T.Type) -> Single<Result<[T], PokemonError>> {
        
        return pokemonProvider.request(target)
            .debug("log:", trimOutput: false).map({ (response) -> Result<[T], PokemonError> in
                do {
                    switch response.statusCode {
                    case 200...204:
                        return try .success(self.decoder.decode([T].self,from:response.data))
                    case 500...:
                        return .failure(PokemonError(code: 400, message: "Internal Server Error"))
                    default:
                        guard let pokemonError = try? self.decoder.decode(PokemonError.self,from:response.data) else {
                            return .failure(PokemonError(unexpected: true))
                        }
                        var error = pokemonError
                        error.code = response.statusCode
                        return .failure(error)
                    }
                }catch let error{
                    return .failure(PokemonError(code: response.statusCode, message: error.localizedDescription))
                }
                
            })
            .observeOn(MainScheduler.instance)
            .asSingle()
    }
}
