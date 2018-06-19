//
//  Post.swift
//  FinalRetake
//
//  Created by MacBook on 6/1/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

import Foundation

struct Post {
    var email: String
    var text: String?
    var timestamp: String
    var type: String
    var userId: String
    var imageURL: String?
    
    init(postDict: [String:Any]) {
        
        email = postDict["email"] as? String ?? ""
        text = postDict["text"] as? String ?? ""
        timestamp = postDict["timestamp"] as? String ?? ""
        type = postDict["type"] as? String ?? ""
        userId = postDict["userId"] as? String ?? ""
        imageURL = postDict["imageURL"] as? String ?? ""
    }
}
