//
//  RestaurantCollectionViewCell.swift
//  Project6solutions
//
//  Created by Natasha Armbrust on 11/6/17.
//  Copyright © 2017 Natasha Armbrust. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegte {
    func collectionViewCellDelegte(didClickButtonAt index: Int)
}

class PostCollectionViewCell: UICollectionViewCell {
    
    var contentLabel: UILabel!
    var likeButton: UIButton! = UIButton()
    var likeLabel: UILabel! = UILabel()
    var numLikes: Int = 0
    var buttonSize: CGFloat = 30
    var userID: Int = -1
    var postID: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.137, green: 0.239, blue: 0.301, alpha: 1)
        contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.font = .systemFont(ofSize: 18)
        contentLabel.numberOfLines = 2
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        layer.cornerRadius = 5
        contentView.addSubview(contentLabel)
        
        likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.font = .systemFont(ofSize: 16)
        likeLabel.textColor = .white
        likeLabel.textAlignment = .right
        likeLabel.text = String(numLikes)
        contentView.addSubview(likeLabel)
        
        likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "unlike"), for: UIControl.State.normal)
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: UIControl.Event.touchUpInside)
        contentView.addSubview(likeButton)
    }
    
    @IBAction func likeButtonPressed() -> Void {
        print("incrementing likes")
        if (likeButton.currentImage == UIImage(named: "unlike")){
            //TODO: SEND LIKE REQUEST
            RestAPI.likeAPost(userID: userID, postID: postID) {
                self.reloadInputViews()
                self.likeButton.setImage(UIImage(named:"like"), for: UIControl.State.normal)
                self.numLikes += 1
                self.likeLabel.text = String(self.numLikes)
            }
        }else{
            //TODO: SEND UNLIKE REQUEST
            RestAPI.unlikeAPost(userID: userID, postID: postID) {
                self.reloadInputViews()
                self.likeButton.setImage(UIImage(named:"unlike"), for: UIControl.State.normal)
                self.numLikes -= 1
                self.likeLabel.text = String(self.numLikes)
            }
        }
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            contentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            contentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            likeButton.heightAnchor.constraint(equalToConstant: buttonSize),
            likeButton.widthAnchor.constraint(equalToConstant: buttonSize),
        ])
        
        NSLayoutConstraint.activate([
            likeLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor,constant: -10),
            likeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeLabel.heightAnchor.constraint(equalToConstant: 20),
//            likeLabel.widthAnchor.constraint(equalToConstant: 40),
            ])
    }
    
    func setup(for post: Post, user_id: Int) {
        userID = user_id
        postID = post.id
        contentLabel.text = post.content
        numLikes = post.likes
        likeLabel.text = String(numLikes)
        if post.liked_by.contains(user_id) {
            likeButton.setImage(UIImage(named:"like"), for: UIControl.State.normal)
        }else{
            likeButton.setImage(UIImage(named:"unlike"), for: UIControl.State.normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

