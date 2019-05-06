//
//  reviews.swift
//  TMDB_HW03.1
//
//  Created by Ryan Hua on 4/10/18.
//  Copyright © 2018 Ryan Hua. All rights reserved.
//

import Foundation
import UIKit

class Reviews: NSObject {
    var numRev: String?
    var id : String?
    var likes : String?
    var dislikes : String?
    init(dictionary: [String: AnyObject]) {
        self.numRev = dictionary["numRev"] as? String
        self.id = dictionary["id"] as? String
        self.likes = dictionary["likes"] as? String
        self.dislikes = dictionary["dislikes"] as? String
    }
}

class Responses : NSObject {
    var like : String?
    var dislike : String?
    var username : String?
    var text : String?
    init (dictionary: [String: AnyObject]) {
        self.like = dictionary["like"] as? String
        self.dislike = dictionary["dislike"] as? String
        self.username = dictionary["username"] as? String
        self.text = dictionary["text"] as? String
    }
}

class FavMovie : NSObject {
    var id : String?
    var poster_path: String?
    var title : String?
    var revnum : String?
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.poster_path = dictionary["poster_path"] as? String
        self.title = dictionary["title"] as? String
        self.revnum = dictionary["revnum"] as? String
    }
}

