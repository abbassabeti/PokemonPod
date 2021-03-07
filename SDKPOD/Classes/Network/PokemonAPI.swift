//
//  PokemonApi.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//


import Foundation
import RxSwift
import Moya
import Alamofire

protocol ProductAPIType {
    var addXAuth: Bool { get }
}

private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

protocol PokemonAPIProtocol {
    
}

enum PokemonAPI {
    case findPokemon(name:String)
    case findSpecies(name:String)
    case findSpeciesByURL(url:String)
    case translateShakespeare(text: String)
    case other
}

extension PokemonAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        switch self {
            case .findPokemon:
                return Configs.Network.pokemonBaseUrl.url!
            case .findSpecies:
                return Configs.Network.pokemonBaseUrl.url!
            case .findSpeciesByURL(let url):
                return url.url!
            case .translateShakespeare:
                return Configs.Network.shakespeare.url!
            default:
                return Configs.Network.pokemonBaseUrl.url!
        }
    }

    var path: String {
        switch self {
            case .findPokemon(let name): return "/api/v2/pokemon/\(name)/"
            case .findSpecies(let name): return "/api/v2/pokemon-species/\(name)"
            case .translateShakespeare: return "/translate/shakespeare.json"
            case .findSpeciesByURL(_): return ""
            default:
                return ""
        }
    }

    var method: Moya.Method {
        switch self {
            case .findPokemon: return .get
            case .findSpecies:return .get
            case .translateShakespeare: return .post
            default:
                return .get
        }
    }

    var headers: [String: String]? {
        //TODO: add headers for API if needed
        return nil
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self{
            case .translateShakespeare(let text):
                params["text"] = text
            default:
                break;
        }
        //TODO: customize parameters in the future if needed
        return params
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var localLocation: URL {
        switch self {
            default: break
        }
        return assetDir
    }

    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }

    public var task: Task {
        switch self {
            default:
                if let parameters = parameters {
                    return .requestParameters(parameters: parameters, encoding: parameterEncoding)
                }
                return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .findPokemon: return getJSONFileData(name:"pokemon")
        case .findSpecies: return getJSONFileData(name:"species")
        case .translateShakespeare: return getJSONFileData(name:"shakespeare")
            default:
                return Data("".utf8)
        }
    }

    var addXAuth: Bool {
        switch self {
        default: return true
        }
    }
    
    func getJSONFileData(name: String) -> Data {
        var data: Data? = nil
        Bundle.allBundles.forEach { (bundle) in
         if let path = bundle.url(forResource: name, withExtension: "json"){
                do {
                      let _data = try Data(contentsOf: path, options: .mappedIfSafe)
                      data = _data
                  } catch {
                  }
            }
        }
        return data ?? Data()
    }
}
