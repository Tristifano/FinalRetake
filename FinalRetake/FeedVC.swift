//
//  FeedVC.swift
//  FinalRetake
//
//  Created by MacBook on 6/1/18.
//  Copyright © 2018 Macbook. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts = [Post](){
        didSet {
            dump(posts)
            feedTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.dataSource = self
        feedTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        observePosts()
    }
   
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
    }
    @IBOutlet weak var feedTableView: UITableView!
    
    
    func observePosts() {
        let postsRef = Database.database().reference().child("posts")
        postsRef.observe(.value) { (snapshot) in
                var posts = [Post]()
            for child in snapshot.children.reversed() {
                    let dataSnapshot = child as! DataSnapshot
                    if let dict = dataSnapshot.value as? [String : Any] {
                        let post = Post.init(postDict: dict)
                        posts.append(post)
                        self.posts = posts
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if post.imageURL != "" {
            let url = URL(string: post.imageURL!)
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell
            cell?.emailLabel.text = post.email
            cell?.timestampLabel.text = post.timestamp
            cell?.postImage.kf.setImage(with: url)
            return cell!
        } else {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as? TextCell
        cell?.cellTextLabel.text = post.text
        cell?.emailLabel.text = post.email
        cell?.timestampLabel.text = post.timestamp
        return cell!
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
