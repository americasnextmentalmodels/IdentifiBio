//
//  User.swift
//  Testee
//
//  Created by Mental ModelsTwo on 2/3/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit

class User: NSObject {
    var firstName: String?
    var lastName: String?
    var email: String?
    var referralCode: String?
    var uid: String?
    
    
    init(dictionary: [String: AnyObject]){
        self.uid = dictionary["uid"] as? String
        self.firstName = dictionary["firstname"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.referralCode = dictionary["referralCode"] as? String
        self.email = dictionary["email"] as? String
        
    }
}
