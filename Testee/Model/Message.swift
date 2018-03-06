//
//  Message.swift
//  Testee
//
//  Created by Mental ModelsTwo on 2/9/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var timestamp: NSNumber?
    var text: String?
    var referralCode: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.referralCode = dictionary["referralCode"] as? String 
    }
    
    func chatPartnerId() -> String? {
//        print("-------CPI TESTING---------")
//        print("toId: " + toId!)
//        print("fromId: " + fromId!)
//        print("uid: " + (Auth.auth().currentUser?.uid)!)
//        print("-------END CPI TESTING---------")
        
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
