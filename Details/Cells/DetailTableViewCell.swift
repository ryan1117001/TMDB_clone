//
//  DetailTableViewCell.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/11/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var link : DetailTableViewController?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    //create array to display cell items
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        var imageArray = [(link?.details?.posterPath)!, (link?.details?.backdrop)!, (link?.details?.posterPath)!, (link?.details?.backdrop)!]
        cell.poster.downloadedFrom(link: ImageURLPrefix+"w342"+imageArray[indexPath.item])
        
        return cell
    }
    let movieTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let releaseDate:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let genres:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let star1:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let star2:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let star3:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let star4:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let star5:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let desc:UILabel = {
        let desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.textAlignment = NSTextAlignment.center
        desc.backgroundColor = .white
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = 0
        desc.font = UIFont.systemFont(ofSize: 15.0)
        return desc
    }()
    let like:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dislike:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Like", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        return button
    }()
    let dislikeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Dislike", for: UIControlState())
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews() {
        let stackview = UIStackView(arrangedSubviews: [star1,star2,star3,star4,star5])
        
        contentView.addSubview(movieTitle)
        contentView.addSubview(releaseDate)
        contentView.addSubview(genres)
        contentView.addSubview(desc)
        contentView.addSubview(stackview)
        
        movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        movieTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        releaseDate.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5).isActive = true
        releaseDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        releaseDate.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        releaseDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        genres.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 5).isActive = true
        genres.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        genres.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: 0.2).isActive = true
        genres.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        stackview.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: 5).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 30).isActive = true
        desc.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 0).isActive = true
        desc.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        desc.heightAnchor.constraint(equalToConstant: 190).isActive = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: contentView.frame.width, height: 0.33*contentView.frame.width)
        let collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: flowLayout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.25).isActive = true
        let stackview1 = UIStackView(arrangedSubviews: [likeButton,like])
        let stackview2 = UIStackView(arrangedSubviews: [dislikeButton,dislike])
        self.addSubview(stackview1)
        stackview1.spacing = 2
        stackview1.translatesAutoresizingMaskIntoConstraints = false
        stackview1.distribution = .fillEqually
        stackview1.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5).isActive = true
        stackview1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 125).isActive = true
        stackview1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        stackview1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(stackview2)
        stackview2.spacing = 2
        stackview2.translatesAutoresizingMaskIntoConstraints = false
        stackview2.distribution = .fillEqually
        stackview2.topAnchor.constraint(equalTo: stackview1.bottomAnchor, constant: 5).isActive = true
        stackview2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 125).isActive = true
        stackview2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100).isActive = true
        stackview2.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
