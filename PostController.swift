//
//  PostController.swift
//  Post
//
//  Created by Colin Smith on 3/18/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PostController {
    
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post] = []
    
    
    func addNewPost(username: String, text: String, completion: @escaping () -> Void){
        var postData: Data
        let newPost = Post(username: username, text: text)
        
        do {
            postData = try JSONEncoder().encode(newPost)
        
        } catch  {
            print("\(error) you suck")
        return
        }
    
    guard let postEndpoint = baseURL else { completion() ; return}
    let fullUrl = postEndpoint.appendingPathExtension("json")
    print(fullUrl.absoluteString)
    var request = URLRequest(url: fullUrl)
        
        
    request.httpMethod = "POST"
    request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("💩 There was an error in \(#function); \(error) ; \(error.localizedDescription)")
                completion()
                return
            }
            
            print(response ?? "No Response")
            
            guard let data = data else {return}
            print(String(data: data, encoding: .utf8))
            
            self.fetchPost(completion: completion)
        }
        dataTask.resume()
    
    }
    
    func fetchPost(completion: @escaping () -> Void) {
        
     //1) Construct the Proper URL
        guard let url = self.baseURL else {return}
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        
        request.httpBody = nil
        request.httpMethod = "GET"
        
        print(request.url?.absoluteString ?? "No URL")
    //2) Call the Datatask (decode and resume) -Actually going to the destination
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("💩 There was an error in \(#function); \(error) ; \(error.localizedDescription)")
                    completion()
                    return
            }
        
            print(response ?? "No Response")
        
            guard let data = data else {return}
            
            do {
                let postDictionary = try JSONDecoder().decode([String:Post].self, from: data)
                var postings = postDictionary.compactMap({$0.value})
                postings.sort(by: {$0.timestamp > $1.timestamp})
                self.posts = postings
                completion()
            }catch{
                
            }
        }
        dataTask.resume()
    }
    
}


