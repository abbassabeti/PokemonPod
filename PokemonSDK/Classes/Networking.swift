//
//  Networking.swift
//  PokemonSDK
//
//  Created by Abbas on 1/6/21.
//

import Foundation
import Moya
import RxSwift
import Alamofire

class OnlineProvider<Target> where Target: Moya.TargetType {
    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>

    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternet()) {
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, session: session, plugins: plugins, trackInflights: trackInflights)
    }

    func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return online
            .ignore(value: false)  // Wait until we're online
            .take(1)        // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in // Turn the online state into a network request
                return actualRequest
        }
    }
    
    func upload(_ token: Target) -> Observable<Moya.ProgressResponse> {
        let actualRequest = provider.rx.requestWithProgress(token)
        return online
            .ignore(value: false)  // Wait until we're online
            .take(1)        // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in // Turn the online state into a network request
                return actualRequest
        }
    }
}

protocol NetworkingType {
    associatedtype T: TargetType, ProductAPIType
    var provider: OnlineProvider<T> { get }
}

struct PokemonNetworking: NetworkingType {
    typealias T = PokemonAPI
    let provider: OnlineProvider<PokemonAPI>
}

// MARK: - "Public" interfaces
extension PokemonNetworking {
    func request(_ token: PokemonAPI) -> Observable<Moya.Response> {
        let actualRequest = self.provider.request(token)
        return actualRequest
    }
    
    func upload(_ token: PokemonAPI) -> Observable<Moya.ProgressResponse> {
        let actualRequest = self.provider.upload(token)
        return actualRequest
    }
}

// Static methods
extension PokemonNetworking {
    static func pokemonNetworking() -> PokemonNetworking {
        return PokemonNetworking(provider: newProvider(plugins))
    }

    static func stubbingPokemonNetworking() -> PokemonNetworking {
        return PokemonNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: PokemonNetworking.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
    }
}

extension NetworkingType {
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType, T: ProductAPIType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)

            // Sign all non-XApp, non-XAuth token requests
            return endpoint
        }
    }

    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }

    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        if Configs.Network.loggingEnabled == true {
            plugins.append(NetworkLoggerPlugin())
        }
        return plugins
    }

    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest() // endpoint.urlRequest
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error{
                
                print("error",error)
                //closure(.failure(error))
                //logError(error.localizedDescription)
            }
        }
    }
}

private func newProvider<T>(_ plugins: [PluginType], xAccessToken: String? = nil) -> OnlineProvider<T> where T: ProductAPIType {
    return OnlineProvider(endpointClosure: PokemonNetworking.endpointsClosure(xAccessToken),
                          requestClosure: PokemonNetworking.endpointResolver(),
                          stubClosure: PokemonNetworking.APIKeysBasedStubBehaviour,
                          plugins: plugins)
}

// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
