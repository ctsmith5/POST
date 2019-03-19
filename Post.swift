//
//  Post.swift
//  Post
//
//  Created by Colin Smith on 3/18/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

struct PostList: Codable {
    let posts: [Post]
}

struct Post: Codable {
    
    let username: String
    let text: String
    let timestamp: TimeInterval
    
    init(username: String, text: String, timeStamp: TimeInterval = TimeInterval() ){
        self.username = username
        self.text = text
        self.timestamp = timeStamp
    }
    
}
