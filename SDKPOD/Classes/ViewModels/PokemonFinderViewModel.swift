//
//  PokemonViewModel.swift
//  PokemonSDK
//
//  Created by Abbas on 1/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PokemonViewModelDelegate : class {
    func reloadSprites()
    func setShakespeareText(text: String)
    func setSaveButtonState(state: Bool)
}

public class PokemonFinderViewModel : NSObject {
    public var spritesList : [(Int,URL)] = []
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    
    weak var delegate : PokemonViewModelDelegate? = nil {
        didSet{
            delegate?.reloadSprites()
            refreshShakespeareText()
        }
    }
    
    public var pokemonModel: PokemonModel? = nil{
        didSet{
            if (pokemonModel != nil){
                self.spritesList = pokemonModel?.getSpritesList() ?? []
                //guard DBHelper.instance.pokemons.value
                if let id = pokemonModel?.id {
                    let state = DBHelper.instance.pokemons.value.contains(where: {$0.id == id})
                    pokemonModel?.isFavorite = state
                    delegate?.setSaveButtonState(state: state)
                }else{
                    delegate?.setSaveButtonState(state: false)
                }
                delegate?.reloadSprites()
                if (pokemonModel?.shakespeare != nil){
                    refreshShakespeareText()
                }
            }else{
                self.spritesList = []
                self.delegate?.setShakespeareText(text: "")
                delegate?.reloadSprites()
            }
        }
    }
    
    func refreshShakespeareText(){
        let text = self.pokemonModel?.shakespeare?.contents.translated ?? ""
        delegate?.setShakespeareText(text: text)
    }
    
    init(delegate: PokemonViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.bindToView()
        DBHelper.fetchEvents()
    }
    
    func bindToView(){
        guard let view = self.delegate as? PokemonFinderView else {return}
        
        view.searchBarTextField?.rx.text.distinctUntilChanged().debounce(.seconds(1), scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: "").drive(onNext: {[weak self] (value) in
            guard let keyword = value else {return}
            guard keyword.count > 0 else {
                self?.pokemonModel = nil
                return
            }
            guard let savedItem = DBHelper.containsItem(keyword: keyword) else {
                DispatchQueue.main.async {
                    view.acitivityIndicatorView?.startAnimating()
                }
                PokemonSDK.findPokemon(name: keyword,view: view) {[weak self] (pokemon) in
                    self?.pokemonModel = pokemon
                    guard let url = pokemon?.species?.url else {return}
                    PokemonSDK.findPokemonShakespeare(url: url,view: view) {[weak self] (shakespeare,error) in
                        DispatchQueue.main.async {
                            view.acitivityIndicatorView?.stopAnimating()
                        }
                        self?.pokemonModel?.shakespeare = shakespeare
                        let text = self?.provideTranslation(pokemon:pokemon,shakespeare:shakespeare,error:error) ?? ""
                        self?.delegate?.setShakespeareText(text: text)
                    }
                }
                return
            }
            self?.pokemonModel = savedItem
            self?.delegate?.setSaveButtonState(state: true)
            let text = self?.provideTranslation(pokemon:savedItem,shakespeare:savedItem.shakespeare,error:nil) ?? ""
            self?.delegate?.setShakespeareText(text: text)
            self?.delegate?.reloadSprites()
            
        }).disposed(by: self.disposeBag)
        
        DBHelper.instance.pokemons.subscribe(onNext: {[weak self] items in
            guard let id = self?.pokemonModel?.id else {return}
            self?.delegate?.setSaveButtonState(state: items.contains(where: {$0.id == id}))
        }).disposed(by: disposeBag)
    }
    
    func provideTranslation(pokemon:PokemonModel?,shakespeare: Shakespeare?,error:PokemonError?) -> String{
        guard let shakespeare = shakespeare else {
            return [pokemon?.name,error?.message].compactMap({$0}).joined(separator: ":\n\n")
        }
        return [pokemon?.name,shakespeare.contents.translated].compactMap({$0}).joined(separator: ":\n\n")
    }
    
    func connectSaveButton(button: UIButton){
        button.rx.tapGesture().asDriver().drive(onNext: { (gr) in
            guard let model = self.pokemonModel else {return}
            DBHelper.togglePokemon(item: model)
        }).disposed(by: disposeBag)
    }
}


extension PokemonFinderViewModel : FavoritePokemonViewDelegate{
    public func loadItem(pokemon: PokemonModel) {
        guard let view = self.delegate as? PokemonFinderView else {return}

        self.pokemonModel = pokemon
        view.searchBarTextField?.text = String(pokemon.id)
    }
    
    
}
