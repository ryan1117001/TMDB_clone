//
//  DetailViewController.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 3/20/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var rating : Double?
    //display four things
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    //create array to display cell items
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        var imageArray = [(details?.posterPath)!, (details?.backdrop)!, (details?.posterPath)!, (details?.backdrop)!]
        cell.poster.downloadedFrom(link: ImageURLPrefix+"w342"+imageArray[indexPath.item])
        
        return cell
    }
    
    //download movie data at start
    
    var details: MovieData?
    var movie: MovieInfo? {
        didSet{
            let id = movie?.id
            let url = URL(string: MovieURLPrefix+"\(id!)?api_key="+APIKey)
            URLSession.shared.dataTask(with: url!) {
                (data,response,error) in
                if error == nil {
                    guard let jsondata = data else {return}
                    do {
                        self.details = try JSONDecoder().decode(MovieData.self, from: jsondata)
                        DispatchQueue.main.async {
                            self.setUpViews()
                        }
                    }catch{
                        print("JSON Downloading Error!")
                    }
                }
                } .resume()
    }
    }
    func setUpViews() {
        //setup constraints for the movie
        
        let movieTitle = UILabel()
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.textAlignment = NSTextAlignment.center
        movieTitle.backgroundColor = .white
        movieTitle.text = "Title: " + (details?.title)!
        
        self.view.addSubview(movieTitle)
        
        movieTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        movieTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0.2).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let releaseDate = UILabel()
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        releaseDate.textAlignment = .center
        releaseDate.backgroundColor = .white
        releaseDate.text = "Release Date: " + (details?.releaseDate)!
        
        self.view.addSubview(releaseDate)
        
        releaseDate.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5).isActive = true
        releaseDate.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        releaseDate.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0.2).isActive = true
        releaseDate.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let genres = UILabel()
        genres.translatesAutoresizingMaskIntoConstraints = false
        genres.textAlignment = .center
        genres.backgroundColor = .white
        var gtemp : String = "Genre: "
        for index in (details?.genres)! {
            gtemp += index.name! + ", "
        }
        genres.text = gtemp
 
        self.view.addSubview(genres)
        
        genres.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 5).isActive = true
        genres.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        genres.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0.2).isActive = true
        genres.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        rating = (details?.rating)!/2
        let star1view = UIImageView(image: getStar(starNumber: 1, forRating: rating!))
        let star2view = UIImageView(image: getStar(starNumber: 2, forRating: rating!))
        let star3view = UIImageView(image: getStar(starNumber: 3, forRating: rating!))
        let star4view = UIImageView(image: getStar(starNumber: 4, forRating: rating!))
        let star5view = UIImageView(image: getStar(starNumber: 5, forRating: rating!))
        let stackview = UIStackView(arrangedSubviews: [star1view,star2view,star3view,star4view,star5view])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.distribution = .fillEqually
        view.addSubview(stackview)
        stackview.topAnchor.constraint(equalTo: genres.bottomAnchor, constant: 5).isActive = true
        stackview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
        stackview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -100).isActive = true
        stackview.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.textAlignment = NSTextAlignment.center
        desc.backgroundColor = .white
        desc.text = "Description: " + (details?.overview)!
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = 0
        desc.font = UIFont.systemFont(ofSize: 15.0)
        self.view.addSubview(desc)
        
        desc.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 0).isActive = true
        desc.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        desc.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
        desc.heightAnchor.constraint(equalToConstant: 190).isActive = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: view.frame.width, height: 0.33*view.frame.width)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: desc.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        
    }
    //star rating setter
    func getStar(starNumber: Double, forRating rating: Double) -> UIImage {
        if rating >= starNumber {
            return #imageLiteral(resourceName: "fullstar")
        } else if rating + 0.5 >= starNumber {
            return #imageLiteral(resourceName: "halfstar")
        } else {
            return #imageLiteral(resourceName: "emptystar")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
