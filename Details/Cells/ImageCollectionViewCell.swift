//
//  ImageCollectionViewCell.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 3/21/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    //collection view setup
    let poster:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        contentView.addSubview(poster)
        //contentView.addSubview(favoriteButton)
        poster.contentMode = .scaleAspectFit
        poster.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        poster.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        poster.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33 ).isActive = true
    }

}
