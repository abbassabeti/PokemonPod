//
//  PokemonSpriteCell.swift
//  PokemonSDK
//
//  Created by Abbas on 1/7/21.
//

import UIKit
import Kingfisher

public class PokemonSpriteCell : UICollectionViewCell {
    
    var imgView: UIImageView?
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView?.kf.cancelDownloadTask()
        imgView?.image = nil
    }
    
    func setupView(){
        let _imgView = UIImageView()
        _imgView.accessibilityIdentifier = "pokemon_img"
        _imgView.contentMode = .scaleAspectFit
        _imgView.translatesAutoresizingMaskIntoConstraints = false
        self.imgView = _imgView
        
        self.accessibilityIdentifier = "pokemon_cell"
        self.contentView.accessibilityIdentifier = "pokemon_content_view"
        
        self.contentView.addSubview(_imgView)
        
        NSLayoutConstraint.activate([
            _imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            _imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            _imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            _imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            _imgView.widthAnchor.constraint(equalToConstant: 120),
            _imgView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    public func configCell(item: URL){
        imgView?.kf.setImage(with: item, placeholder: UIImage(named: "sprite_placeholder"), options: nil, completionHandler: nil)
    }
}
