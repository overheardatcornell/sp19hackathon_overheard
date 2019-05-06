//
//  ViewController.swift
//  p3
//
//  Created by Matthew Barker on 3/3/18.
//  Copyright © 2018 Walker White. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var name: String? = "My Profile"
    
    let likeReuseIdentifier = "likeReuseIdentifier"
    let postReuseIdentifier = "postReuseIdentifier"
    
    var likedPosts: [Post]! = []
    var postedPosts: [Post]! = []
    
//    var userLabel: UILabel = UILabel()
//    var userIDLabel: UILabel = UILabel()
    var likeLabel: UILabel = UILabel()
    var likeCollectionView: UICollectionView!
    var postLabel: UILabel = UILabel()
    var postCollectionView: UICollectionView!
    var user: Int
    
    var offset: CGFloat = 20
    
    init(userId: Int) {
        user = userId;
        super.init(nibName: nil, bundle: nil)
        
//        userLabel = UILabel()
//        userLabel.translatesAutoresizingMaskIntoConstraints = false
//        userLabel.text = "User ID"
//        userLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        userLabel.textColor = .black
//
//        userIDLabel = UILabel()
//        userIDLabel.translatesAutoresizingMaskIntoConstraints = false
//        userIDLabel.font = UIFont.systemFont(ofSize: 16)
//        userIDLabel.textColor = .black
        
        likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.text = "Liked"
        likeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        likeLabel.textColor = .black
        
        postLabel = UILabel()
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        postLabel.text = "Posted"
        postLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        postLabel.textColor = .black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        view.backgroundColor = .white

//        view.addSubview(userLabel)
//        view.addSubview(userIDLabel)
        view.addSubview(likeLabel)
        
        likeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ProfilePostCollectionViewFlowLayout())
        likeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        likeCollectionView.delegate = self
        likeCollectionView.dataSource = self
        likeCollectionView.register(ProfilePostCollectionViewCell.self, forCellWithReuseIdentifier: likeReuseIdentifier)
        likeCollectionView.showsHorizontalScrollIndicator = false
        likeCollectionView.backgroundColor = .clear
        likeCollectionView.allowsMultipleSelection = true //this is how we select multiple cells at once
        
        view.addSubview(likeCollectionView)
        view.addSubview(postLabel)
        
        postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ProfilePostCollectionViewFlowLayout())
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(ProfilePostCollectionViewCell.self, forCellWithReuseIdentifier: postReuseIdentifier)
        postCollectionView.showsHorizontalScrollIndicator = false
        postCollectionView.backgroundColor = .clear
        postCollectionView.allowsMultipleSelection = true //this is how we select multiple cells at once
        
        view.addSubview(postCollectionView)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
//        NSLayoutConstraint.activate([
//            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
//            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
//            userLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
//            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            userLabel.heightAnchor.constraint(equalToConstant: 20)
//            ])
//        NSLayoutConstraint.activate([
//            userIDLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
//            userIDLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
//            userIDLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: offset),
//            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//            userIDLabel.heightAnchor.constraint(equalToConstant: 20)
//            ])
        NSLayoutConstraint.activate([
            likeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            likeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            likeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset+10),
            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            likeLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            likeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            likeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            likeCollectionView.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: offset+10),
            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            likeCollectionView.heightAnchor.constraint(equalToConstant: 160)
            ])
        NSLayoutConstraint.activate([
            postLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            postLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            postLabel.topAnchor.constraint(equalTo: likeCollectionView.bottomAnchor, constant: offset+10),
            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            postLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            postCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            postCollectionView.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: offset+10),
            //            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            postCollectionView.heightAnchor.constraint(equalToConstant: 160)
            ])
    }
    
    //TODO: NEEDS INPUT FROM DATABASE FOR THE LIKED/POSTED POSTS
    func config(){
//        userIDLabel.text = "testuser"
        RestAPI.getAUser(userId: user) {
            userResponse in print("Displaying liked/posted posts succedded");
            let user_likedPosts = userResponse.data.user_liked
            let user_postedPosts = userResponse.data.posts
            self.likedPosts = []
            self.postedPosts = []
            for ulp in user_likedPosts{
                self.likedPosts.append(ulp.post())
            }
            for upp in user_postedPosts{
                self.postedPosts.append(upp.post())
            }
            self.likeCollectionView.reloadData()
            self.postCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == likeCollectionView {
            return likedPosts.count
        }
        else {
            return postedPosts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == likeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: likeReuseIdentifier, for: indexPath) as! ProfilePostCollectionViewCell
            let post = likedPosts[indexPath.item]
            cell.config(for: post, user_id: user)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postReuseIdentifier, for: indexPath) as! ProfilePostCollectionViewCell
            let post = postedPosts[indexPath.item]
            cell.config(for: post, user_id: user)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == likeCollectionView {
            let currentPost = likedPosts[indexPath.item]
            RestAPI.getAPost(userId: user, postId: currentPost.id){
                post in
                self.pushViewPostController(post: post)
                self.postCollectionView.reloadData()
            }
        }
        else {
            let currentPost = postedPosts[indexPath.item]
            RestAPI.getAPost(userId: user, postId: currentPost.id){
                post in
                self.pushViewPostController(post: post)
                self.postCollectionView.reloadData()
            }
        }
    }
    
    
    func pushViewPostController(post : Post) {
        let postViewController = PostViewController()
        postViewController.config(for: post, user_id: user, username: (UIDevice.current.identifierForVendor?.uuidString)!)
        navigationController?.pushViewController(postViewController, animated: true)
        
        // Change title from being default back button text
        let backButton = UIBarButtonItem()
        backButton.title = "My Profile"
        navigationItem.backBarButtonItem = backButton
    }
    
}


