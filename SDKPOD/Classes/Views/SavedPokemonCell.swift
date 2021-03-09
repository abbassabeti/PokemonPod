//
//  SavedPokemonCell.swift
//  PokemonSDK
//
//  Created by Abbas on 1/8/21.
//

import UIKit
import Kingfisher

class SavedPokemonCell : UITableViewCell {
    var imgView: UIImageView?
    var nameLbl: UILabel?
    var idLbl: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLbl?.text = ""
        self.imgView?.image = nil
        self.imgView?.kf.cancelDownloadTask()
    }
    
    func setupView(){
        let _imgView = UIImageView()
        let _nameLbl = UILabel()
        let _idLbl = UILabel()
        
        _imgView.accessibilityIdentifier = "favorite_image"
        _nameLbl.accessibilityIdentifier = "favorite_name"
        _idLbl.accessibilityIdentifier = "favorite_id"
        self.accessibilityIdentifier = "favorite_cell"
        self.contentView.accessibilityIdentifier = "favorite_content_view"
//        let _backView = UIView()
//        self.backgroundView = _backView
//        print("holla back is\(self.backgroundView.debugDescription)")
//        self.backgroundView?.layer.cornerRadius = 8
//        self.backgroundView?.backgroundColor = .white
//        self.backgroundView?.layer.shadowOffset = CGSize(width: 1, height: 3)
//        self.backgroundView?.layer.shadowColor = UIColor.gray.cgColor
        
        _imgView.translatesAutoresizingMaskIntoConstraints = false
        _nameLbl.translatesAutoresizingMaskIntoConstraints = false
        _idLbl.translatesAutoresizingMaskIntoConstraints = false
        
        _imgView.contentMode = .scaleAspectFit
        _nameLbl.textColor = .darkGray
        _idLbl.textColor = .darkGray
        
        self.nameLbl = _nameLbl
        self.imgView = _imgView
        self.idLbl = _idLbl
        
        self.contentView.addSubview(_imgView)
        self.contentView.addSubview(_nameLbl)
        self.contentView.addSubview(_idLbl)
        
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            _nameLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -35),
            _nameLbl.leadingAnchor.constraint(equalTo: _imgView.trailingAnchor, constant: 15),
            _nameLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            _idLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 35),
            _idLbl.leadingAnchor.constraint(equalTo: _imgView.trailingAnchor, constant: 15),
            _idLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            _imgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            _imgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            _imgView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            _imgView.widthAnchor.constraint(equalToConstant: 120),
            _imgView.heightAnchor.constraint(equalToConstant: 120),
            self.contentView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    func configCell(name: String,id: Int,img: String?){
        self.nameLbl?.text = name
        self.idLbl?.text = String(id)
        guard let _img = img else {return}
        self.imgView?.kf.setImage(with: URL(string: _img),placeholder: UIImage(named: "sprite_placeholder"))
    }
}
