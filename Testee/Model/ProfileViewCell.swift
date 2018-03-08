//
//  ProfileViewCell.swift
//  Testee
//
//  Created by Mental ModelsTwo on 3/7/18.
//  Copyright © 2018 Mental ModelsTwo. All rights reserved.
//

import UIKit

class ProfileViewCell: NSObject {
    var cellTitle: String?
    var cellSubtitle: String?
    
    init(dictionary: [String: Any]) {
        self.cellTitle = dictionary["cellTitle"] as? String
        self.cellSubtitle = dictionary["cellSubtitle"] as? String
    }
}

