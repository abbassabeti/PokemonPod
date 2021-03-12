//
//  PokemonSearchBar.swift
//  PokemonSDK
//
//  Created by Abbas on 1/7/21.
//

import UIKit
import RxCocoa

// MARK: - PokemonFinderView

public class PokemonFinderView : UIView {
    
    let cellIdentifier :String = "PokemonSpriteCell"
    
    var searchBarTextField : UITextField?
    var spritsCollectionView : UICollectionView?
    var shakespeareTextView : UITextView?
    var saveButton: UIButton?
    var acitivityIndicatorView: UIActivityIndicatorView?
    
    public var viewModel : PokemonFinderViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    init() {
        super.init(frame: CGRect())
        setupView()
    }
    
    
    func setupView(){
        setupConstraints()
        self.viewModel = PokemonFinderViewModel(delegate: self)
        guard let button = self.saveButton else {return}
        self.viewModel?.connectSaveButton(button: button)
    }
    
    func setupConstraints(){
        let _searchBarTextField = UITextField()
        let _shakespeareTextView = UITextView()
        let _spritsCollectionView = setupCollectionView()
        let _saveButton = UIButton()
        let _activityIndView = UIActivityIndicatorView()
        _activityIndView.color = .gray
        
        _searchBarTextField.accessibilityIdentifier = "pokemon_text_field"
        _shakespeareTextView.accessibilityIdentifier = "pokemon_shakespeare_text_view"
        _spritsCollectionView.accessibilityIdentifier = "pokemon_collection_view"
        _saveButton.accessibilityIdentifier = "pokemon_save_button"
        _activityIndView.accessibilityIdentifier = "pokemon_activity_indicator"
        self.accessibilityIdentifier = "pokemon_finder_view"
        
        self.translatesAutoresizingMaskIntoConstraints = false
        _searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
        _spritsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        _shakespeareTextView.translatesAutoresizingMaskIntoConstraints = false
        _saveButton.translatesAutoresizingMaskIntoConstraints = false
        _activityIndView.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBarTextField = _searchBarTextField
        self.spritsCollectionView = _spritsCollectionView
        self.shakespeareTextView = _shakespeareTextView
        self.saveButton = _saveButton
        self.acitivityIndicatorView = _activityIndView
        
        _shakespeareTextView.backgroundColor = .white
        _shakespeareTextView.layer.cornerRadius = 8
        _shakespeareTextView.layer.borderWidth = 1
        _shakespeareTextView.layer.borderColor = UIColor.gray.cgColor
        _shakespeareTextView.isEditable = false
        _shakespeareTextView.textColor = UIColor.darkGray
        _shakespeareTextView.delegate = self
        _searchBarTextField.layer.cornerRadius = 8
        _searchBarTextField.layer.borderWidth = 1
        _searchBarTextField.layer.borderColor = UIColor.gray.cgColor
        _searchBarTextField.textColor = .black
        _searchBarTextField.attributedPlaceholder = NSAttributedString(string: "Enter Pokemon Name or ID",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        _searchBarTextField.textAlignment = .center
        _spritsCollectionView.layer.cornerRadius = 8
        _spritsCollectionView.layer.borderWidth = 1
        _spritsCollectionView.layer.borderColor = UIColor.gray.cgColor
        _saveButton.setTitle("Save", for: .normal)
        _saveButton.setTitleColor(UIColor.blue, for: .normal)
        _activityIndView.hidesWhenStopped = true
        
        self.addSubview(_searchBarTextField)
        self.addSubview(_spritsCollectionView)
        self.addSubview(_shakespeareTextView)
        self.addSubview(_saveButton)
        self.addSubview(_activityIndView)
        
        NSLayoutConstraint.activate([
            _searchBarTextField.heightAnchor.constraint(equalToConstant: 45),
            _searchBarTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: self.safeAreaInsets.top + 15),
            _searchBarTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            _searchBarTextField.trailingAnchor.constraint(equalTo: _saveButton.leadingAnchor, constant: -10),
            _saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            _saveButton.widthAnchor.constraint(equalToConstant: 90),
            _saveButton.heightAnchor.constraint(equalToConstant: 30),
            _saveButton.centerYAnchor.constraint(equalTo: _searchBarTextField.centerYAnchor),
            _spritsCollectionView.topAnchor.constraint(equalTo: _searchBarTextField.bottomAnchor, constant: 15),
            _spritsCollectionView.heightAnchor.constraint(equalToConstant: 140),
            _spritsCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            _spritsCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            _shakespeareTextView.topAnchor.constraint(equalTo: _spritsCollectionView.bottomAnchor, constant: 15),
            _shakespeareTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            _shakespeareTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            _shakespeareTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.safeAreaInsets.bottom - 15),
            _activityIndView.centerYAnchor.constraint(equalTo: _spritsCollectionView.centerYAnchor, constant: 0),
            _activityIndView.centerXAnchor.constraint(equalTo: _spritsCollectionView.centerXAnchor, constant: 0),
        ])
    }
    
    func setupCollectionView() -> UICollectionView{
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 130, height: 120)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let _spritsCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        _spritsCollectionView.backgroundColor = .clear
        _spritsCollectionView.bounces = true
        _spritsCollectionView.isScrollEnabled = true
        _spritsCollectionView.register(PokemonSpriteCell.self, forCellWithReuseIdentifier: cellIdentifier)
        _spritsCollectionView.delegate = self
        _spritsCollectionView.dataSource = self
        _spritsCollectionView.reloadData()
        return _spritsCollectionView
    }
}

// MARK: - CollectionView DataSource

extension PokemonFinderView : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.spritesList.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PokemonSpriteCell else {return UICollectionViewCell()}
        guard let items = self.viewModel?.spritesList else {return cell}
        guard items.count > indexPath.row else {return cell}
        let item = items[indexPath.row]
        cell.configCell(item: item.1)
        return cell
    }
    
    
}


// MARK: - CollectionView Delegate

extension PokemonFinderView : UICollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBarTextField?.endEditing(true)
    }
}

extension PokemonFinderView : PokemonViewModelDelegate {
    func reloadSprites() {
        self.spritsCollectionView?.reloadData()
        self.spritsCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
    
    func setShakespeareText(text: String) {
        self.shakespeareTextView?.text = text
    }
    
    func setSaveButtonState(state: Bool,enabled: Bool){
        self.saveButton?.setTitle(state ? "Saved" : "Save", for: .normal)
        self.saveButton?.backgroundColor = state ? UIColor.green.withAlphaComponent(0.5) : UIColor.white
        self.saveButton?.isEnabled = enabled
    }

}

extension PokemonFinderView : UITextViewDelegate {
}
