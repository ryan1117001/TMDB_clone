//
//  MovieInfo.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 3/19/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import Foundation

let APIKey: String = "3b33d87f6bd1e83d155db50903351f9b"
let MovieURLPrefix = "https://api.themoviedb.org/3/movie/"
let ImageURLPrefix = "https://image.tmdb.org/t/p/"

struct MovieInfo: Decodable {
    let id: Int?
    let poster_path: String?
    let title: String?
}

struct MovieResults: Decodable {
    let page: Int?
    let numResults: Int?
    let numPages: Int?
    var movies: [MovieInfo]
    
    private enum CodingKeys: String, CodingKey {
        case page, numResults = "total_results", numPages = "total_pages", movies = "results"
    }
}

struct MovieData: Decodable {
    let id: Int?
    let posterPath: String?
    let backdrop: String?
    let title: String?
    let releaseDate: String?
    let rating: Double?
    let overview: String?
    let genres: [MovieGenre]
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", backdrop = "backdrop_path",title, releaseDate = "release_date", rating = "vote_average", overview, genres
    }
}
struct MovieGenre: Decodable {
    let id: Int?
    let name: String?
}
