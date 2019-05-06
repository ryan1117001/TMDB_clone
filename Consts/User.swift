//
//  User.swift
//  ToDoListWithFirebase
//
//  Created by Mina Jung on 02/04/2018.
//  Copyright © 2018 Mina Jung. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String?
    var email: String?
    var fullname: String?
    var hometown: String?
    var occupation: String?
    var profileurl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.username = dictionary["username"] as? String
        self.email = dictionary["email"] as? String
        self.fullname = dictionary["fullname"] as? String
        self.hometown = dictionary["hometown"] as? String
        self.occupation = dictionary["occupation"] as? String
        self.profileurl = dictionary["profileurl"] as? String
    }
}
