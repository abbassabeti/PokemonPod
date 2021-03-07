//
//  ExposedPokemon.swift
//  PokemonSDK
//
//  Created by Abbas on 1/7/21.
//

import Foundation
import RxSwift
import RxCocoa


public class PokemonSDK{

    static let instance = PokemonSDK()
    var provider: RestApi = RestApi(pokemonProvider: PokemonNetworking.pokemonNetworking())
    let disposeBag = DisposeBag()
    
    var isMock : Bool = false {
        didSet{
            if (isMock){
                provider = RestApi(pokemonProvider: PokemonNetworking.stubbingPokemonNetworking())
            }else{
                guard oldValue != isMock else {return}
                provider = RestApi(pokemonProvider: PokemonNetworking.pokemonNetworking())
            }
        }
    }
    
    public class func findPokemonSprite(name: String,view: PokemonFinderView? = nil,completion: @escaping (Sprites?) ->()){
        instance.provider.getPokemon(name: name).asDriver(onErrorJustReturn: .failure(PokemonError(unexpected: true))).drive(onNext: { (result) in
                        switch result {
                            case .success(let pokemon):
                                view?.viewModel?.pokemonModel = pokemon
                                completion(pokemon.sprites)
                            case .failure(_):
                                completion(nil)
                                
                        }
                    }).disposed(by: instance.disposeBag)
    }
    
    public class func findPokemon(name: String,view: PokemonFinderView? = nil,completion: @escaping (PokemonModel?) ->()){
        instance.provider.getPokemon(name: name).asDriver(onErrorJustReturn: .failure(PokemonError(unexpected: true))).drive(onNext: { (result) in
                        switch result {
                            case .success(let pokemon):
                                view?.viewModel?.pokemonModel = pokemon
                                completion(pokemon)
                            case .failure(_):
                                completion(nil)
                                
                        }
                    }).disposed(by: instance.disposeBag)
    }
    
    public class func findPokemonShakespeare(name: String,view: PokemonFinderView? = nil,completion: @escaping (Shakespeare?,PokemonError?) ->()){
        instance.provider.getSpecies(name: name).asDriver(onErrorJustReturn: .failure(PokemonError(unexpected: true))).drive(onNext: { (result) in
                        switch result {
                            case .success(let species):
                                let description = species.flavorTextEntries.map({$0.flavorText}).joined(separator: "\n")
                                translateShakespeare(text: description,view: view, completion: completion)
                            case .failure(let error):
                                completion(nil,error)
                                
                        }
                    }).disposed(by: instance.disposeBag)
    }
    
    class func translateShakespeare(text: String,view: PokemonFinderView? = nil,completion: @escaping (Shakespeare?,PokemonError?) -> ()){
        instance.provider.getShakespeare(text: text).asDriver(onErrorJustReturn: .failure(PokemonError(unexpected: true))).drive(onNext: { (result) in
                        switch result {
                            case .success(let translation):
                                view?.viewModel?.pokemonModel?.shakespeare = translation
                                completion(translation,nil)
                            case .failure(let error):
                                completion(nil,error)
                                
                        }
                    }).disposed(by: instance.disposeBag)
    }
    
    public class func findPokemonShakespeare(url: String,view: PokemonFinderView? = nil,completion: @escaping (Shakespeare?,PokemonError?) ->()){
        instance.provider.getSpecies(url: url).asDriver(onErrorJustReturn: .failure(PokemonError(unexpected: true))).drive(onNext: { (result) in
                        switch result {
                            case .success(let species):
                                let description = species.flavorTextEntries.map({$0.flavorText}).joined(separator: "")
                                let item = Shakespeare(success: Success(total: 1), contents: Contents(translated: description, text: description, translation: description))
                                view?.viewModel?.pokemonModel?.shakespeare = item
                                //completion(item)
                                translateShakespeare(text: description,view: view, completion: completion)
                            case .failure(let error):
                                completion(nil,error)
                                
                        }
                    }).disposed(by: instance.disposeBag)
    }
}
