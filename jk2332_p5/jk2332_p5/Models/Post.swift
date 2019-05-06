//
//  Restaurant.swift
//  jk2332_p5
//
//  Created by 김지원 on 4/14/19.
//  Copyright © 2019 김지원. All rights reserved.
//

import Foundation
import UIKit

struct Post: Codable{

    var id: Int
    var tags: [Tag]!
    var content: String
    var username: String
    var likes: Int
    var liked_by: [Int]
    var title: String
    
    init(ptitle: String, tagList: [Tag]! = [], cont: String, user_id : Int, like_num : Int){
        id = -1
        title = ptitle
        tags = tagList
        content = cont
        username = String(user_id)
        likes = like_num
        liked_by = []
    }
    
    init(id: Int, title: String, tags: [Tag]!, content: String, username : String, likes : Int, liked_by: [Int]!){
        self.id = id
        self.title = title
        self.tags = tags
        self.content = content
        self.username = username
        self.likes = likes
        self.liked_by = liked_by
    }
    
    init(id: Int, title: String, tags: [Tag]!, content: String, username : String, likes : Int){
        self.id = id
        self.title = title
        self.tags = tags
        self.content = content
        self.username = username
        self.likes = likes
        self.liked_by = []
    }
}

struct PostResponse: Codable {
    var data: [Post]
}

struct RawPost: Codable {
    var content: String
    var id: Int
    var liked_by: [UserResponse]
    var likes: Int
    var tags: String
    var title: String
    var username: String
    
    func post() -> Post {
        let postData = self
        let tagstringlist = postData.tags.components(separatedBy: ",")
        var taglist: [Tag] = []
        for tagstring in tagstringlist{
            taglist.append(Tag(name: tagstring))
        }
        var likelist: [Int] = []
        for likeuser in postData.liked_by {
            likelist.append(likeuser.id)
        }
        return Post(
            id: postData.id,
            title: postData.title,
            tags: taglist,
            content: postData.content,
            username: postData.username,
            likes: postData.likes,
            liked_by: likelist
        )
    }
}

struct CreatePostResponse: Codable {
    var data: Post
}

struct RawPostResponse: Codable {
    var data: [RawPost]
    
    func postArray() -> PostResponse {
        let postResponseData = self
        var postlist: [Post] = []
        for postCD in postResponseData.data{
            postlist.append(postCD.post())
        }
        return PostResponse(data: postlist)
    }
}

struct RawCreatePostResponse: Codable {
    var data: RawPost
    
    func createPostResponse() -> CreatePostResponse {
        return CreatePostResponse(data: data.post())
    }
}
