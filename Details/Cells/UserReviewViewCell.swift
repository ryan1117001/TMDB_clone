//
//  UserReviewViewCell.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/11/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit

class UserReviewViewCell: UITableViewCell {
    var link : DetailTableViewController?
    var un : String?
    let username:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    let review: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Review"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Submit", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())

        return button
    }()
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Delete", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        
        return button
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        
        self.addSubview(username)
        self.addSubview(review)
        username.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        username.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        username.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -60).isActive = true
        username.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        review.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        review.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        review.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        review.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let stackview1 = UIStackView(arrangedSubviews: [likeButton,like])
        let stackview2 = UIStackView(arrangedSubviews: [dislikeButton,dislike])
        
        self.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: review.bottomAnchor, constant: 5).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 75).isActive = true
        submitButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -100).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 5).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 75).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -100).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(stackview1)
        stackview1.spacing = 2
        stackview1.translatesAutoresizingMaskIntoConstraints = false
        stackview1.distribution = .fillEqually
        stackview1.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 5).isActive = true
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
