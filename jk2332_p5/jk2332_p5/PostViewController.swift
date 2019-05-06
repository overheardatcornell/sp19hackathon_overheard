//
//  ViewController.swift
//  p3
//
//  Created by Matthew Barker on 3/3/18.
//  Copyright © 2018 Walker White. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var name: String? = "Quote"
    
    let postTagReuseIdentifier = "postReuseIdentifier"
    
    var postTags: [Tag]!
    
    var quoteLabel: UILabel = UILabel()
    var titleLabel: UILabel = UILabel()
    var authorLabel: UILabel = UILabel()
    var likesLabel: UILabel = UILabel()
    var likeButton: UIButton = UIButton()
    var postTagCollectionView: UICollectionView!
    var deleteButton: UIButton = UIButton()
    
    var offset: CGFloat = 18
    let iconSize: CGFloat = 18
    
    var numLikes: Int = -1
    var userName: String = ""
    var writerName: String = ""
    var userID: Int = -1
    var postID: Int = -1
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Create Elements
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        quoteLabel = UILabel()
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        quoteLabel.backgroundColor = UIColor(red: 0.137, green: 0.239, blue: 0.301, alpha: 1)
        quoteLabel.textColor = .white
        quoteLabel.textAlignment = .center
        quoteLabel.layer.masksToBounds = true
        quoteLabel.layer.cornerRadius = 10
        quoteLabel.contentMode = .scaleToFill
        quoteLabel.numberOfLines = 0
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textColor = .black
        
        likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        likesLabel.textColor = .white
        likesLabel.textAlignment = .right
        
        likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "unlike"), for: UIControl.State.normal)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControl.Event.touchUpInside)
        
        deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: UIControl.Event.touchUpInside)
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 10
        deleteButton.backgroundColor = UIColor(red: 0.137, green: 0.239, blue: 0.301, alpha: 1)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postTagReuseIdentifier, for: indexPath) as! TagCollectionViewCell
        let tag = postTags[indexPath.item]
        cell.setup(for: tag)
        return cell
    }
    
    @IBAction func likeButtonPressed() -> Void {
        print("incrementing likes")
        if (likeButton.currentImage == UIImage(named: "unlike")){
            //TODO: SEND LIKE REQUEST
            RestAPI.likeAPost(userID: userID, postID: postID) {
                self.reloadInputViews()
                self.likeButton.setImage(UIImage(named:"like"), for: UIControl.State.normal)
                self.numLikes += 1
                self.likesLabel.text = String(self.numLikes)
            }
        }else{
            //TODO: SEND UNLIKE REQUEST
            RestAPI.unlikeAPost(userID: userID, postID: postID) {
                self.reloadInputViews()
                self.likeButton.setImage(UIImage(named:"unlike"), for: UIControl.State.normal)
                self.numLikes -= 1
                self.likesLabel.text = String(self.numLikes)
            }
        }
        
    }
    
    @IBAction func deleteButtonPressed() -> Void {
        print("delete post")
        RestAPI.deleteAPost(userId: userID, postId: postID){
            postResponse in
            self.navigationController?.popViewController(animated: true)
            print("reload")
            guard let vc = self.navigationController?.visibleViewController as? ViewController else {
                print("reloadfail")
                return }
            vc.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        view.backgroundColor = .white
        
        // Add Elements
        view.addSubview(quoteLabel)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(likesLabel)
        view.addSubview(likeButton)
        if (writerName == userName){
            view.addSubview(deleteButton)
        }
        postTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilterCollectionViewFlowLayout())
        postTagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postTagCollectionView.delegate = self
        postTagCollectionView.dataSource = self
        postTagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: postTagReuseIdentifier)
        postTagCollectionView.showsHorizontalScrollIndicator = false
        postTagCollectionView.backgroundColor = .clear
        postTagCollectionView.allowsMultipleSelection = true //this is how we select multiple cells at once
        view.addSubview(postTagCollectionView)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            quoteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
//            quoteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            quoteLabel.heightAnchor.constraint(equalToConstant: 300)
            ])
        NSLayoutConstraint.activate([
            //            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            likeButton.trailingAnchor.constraint(equalTo: quoteLabel.trailingAnchor, constant: -offset),
            likeButton.bottomAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: -offset),
            likeButton.heightAnchor.constraint(equalToConstant: iconSize),
            likeButton.widthAnchor.constraint(equalToConstant: iconSize)
            ])
        NSLayoutConstraint.activate([
            //            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            likesLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -5),
            likesLabel.bottomAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: -offset),
            likesLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
        NSLayoutConstraint.activate([
            postTagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            postTagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            postTagCollectionView.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 10),
            postTagCollectionView.heightAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            titleLabel.topAnchor.constraint(equalTo: postTagCollectionView.bottomAnchor, constant: offset),
            titleLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            //            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
        
        if (writerName == userName){
        NSLayoutConstraint.activate([
            //            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset+5),
            deleteButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            ])
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let point = touches.first?.location(in: view) {
//           
//        }
    }
    
    func config(for postinfo: Post, user_id: Int, username: String){
        userID = user_id
        postID = postinfo.id
        quoteLabel.text = "\""+postinfo.content+"\""
        titleLabel.text = postinfo.title
        authorLabel.text = "User ID: "+String(postinfo.username)
        if (postinfo.likes<1000) {
            likesLabel.text = String(postinfo.likes)
        } else {
            likesLabel.text = String(postinfo.likes/1000)+"."+String((postinfo.likes%1000)/100)+"K"
        }
        name = postinfo.title
        postTags = postinfo.tags
        writerName = postinfo.username
        userName = username
        numLikes = postinfo.likes
        
        //TODO: CHECK IF THE USER LIKED THIS POST OR NOT
        if (postinfo.liked_by.contains(userID)){
            likeButton.setImage(UIImage(named:"like"), for: UIControl.State.normal)
        } else {
            likeButton.setImage(UIImage(named:"unlike"), for: UIControl.State.normal)
        }
    }
    
}



