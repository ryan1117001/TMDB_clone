//
//  UpcomingMovieCell.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 3/21/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit

class UpcomingMovieCell: UITableViewCell {

    var link: UpcomingTableViewController?
    let movieTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moviePoster:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let revNum:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let favButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Favorite", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        return button
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        
        contentView.addSubview(movieTitle)
        contentView.addSubview(moviePoster)
        contentView.addSubview(revNum)
        contentView.addSubview(favButton)
        
        movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        movieTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        revNum.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5).isActive = true
        revNum.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        revNum.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        revNum.heightAnchor.constraint(equalToConstant: 20).isActive = true
        moviePoster.topAnchor.constraint(equalTo: revNum.bottomAnchor, constant: 5).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        moviePoster.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        moviePoster.heightAnchor.constraint(equalToConstant: 300).isActive = true
        favButton.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: 5).isActive = true
        favButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100).isActive = true
        favButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        favButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
