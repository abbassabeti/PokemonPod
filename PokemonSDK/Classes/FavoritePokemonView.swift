//
//  FavoritePokemonView.swift
//  PokemonSDK
//
//  Created by Abbas on 1/8/21.
//

import UIKit

public protocol FavoritePokemonViewDelegate:class {
    func loadItem(pokemon:PokemonModel)
}

public protocol FavoritePokemonViewParentDelegate: class{
    func getBackToMainView()
}

public class FavoritePokemonView : UIView {
    var tableView: UITableView?
    
    public weak var delegate : FavoritePokemonViewDelegate?
    public weak var parentDelegate : FavoritePokemonViewParentDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    init(delegate: FavoritePokemonViewDelegate) {
        super.init(frame: CGRect())
        setupView()
        self.delegate = delegate
    }
    
    func setupView(){
        let _tableView = UITableView()
        self.translatesAutoresizingMaskIntoConstraints = false
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.backgroundColor = .white
        self.tableView = _tableView
        self.addSubview(_tableView)
        
        NSLayoutConstraint.activate([
            _tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            _tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            _tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            _tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = UITableView.automaticDimension
        _tableView.estimatedRowHeight = 150
        _tableView.register(SavedPokemonCell.self, forCellReuseIdentifier: "saved_item")
        _tableView.reloadData()
    }
}

extension FavoritePokemonView : UITableViewDelegate{
    
}

extension FavoritePokemonView : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBHelper.instance.pokemons.value.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = getItem(index: indexPath.row) else {return}
        
        delegate?.loadItem(pokemon: item)
        parentDelegate?.getBackToMainView()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "saved_item") as? SavedPokemonCell else {return UITableViewCell()}
        guard let item = getItem(index: indexPath.row) else {return cell}
        cell.configCell(name: item.name,id: item.id ,img: item.sprites.frontDefault)
        
        return cell
    }
    
    func getItem(index: Int) -> PokemonModel? {
        let items = DBHelper.instance.pokemons.value
        guard index < items.count else {return nil}
        return items[index]
    }
    
    
}
