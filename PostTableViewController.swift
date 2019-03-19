//
//  PostTableViewController.swift
//  Post
//
//  Created by Colin Smith on 3/18/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    
    var postController = PostController()
    var post: Post?
    var refrescoControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        postController.fetchPost{
            
            self.reloadTableView()
        }
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refrescoControl
        
    }

    // MARK: - Table view data source
    @objc func refreshControlPulled() {
            refreshControl?.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        refrescoControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.refrescoControl.endRefreshing()
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postController.posts.count
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        
       

        return cell
    }
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let newItem = UIAlertController(title: "Enter New Post", message: "Say something Witty", preferredStyle: .alert)
        newItem.addTextField{ (textfield) in
            textfield.placeholder = "UserName"}
        newItem.addTextField{ (textfield) in
            textfield.placeholder = "TextMeSomething"}
       
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (addItem) in
            if let usernameTextField = newItem.textFields?[0].text,
            let messageTextField = newItem.textFields?[1].text{
               // New content to be Posted
                self.postController.addNewPost(username: usernameTextField, text: messageTextField, completion: {
                    self.reloadTableView()
                })
            }
            
            
        }
        newItem.addAction(cancelAction)
        newItem.addAction(addAction)
        reloadTableView()
        self.present(newItem, animated: true, completion: nil)
        
    }
    

   
   

}

