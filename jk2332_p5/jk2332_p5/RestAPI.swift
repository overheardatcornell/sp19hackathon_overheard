//
//  RestAPI.swift
//  Project6solutions
//
//  Created by Natasha Armbrust on 11/6/17.
//  Copyright © 2017 Natasha Armbrust. All rights reserved.
//

import Foundation
import Alamofire

class RestAPI {
    private static let postEndpoint = "http://35.196.182.82/posts/"
    private static let addUserEndpoint = "http://35.196.182.82/users/"
    private static let endpoint = "http://35.196.182.82"
    
    static func getPosts() -> [Post] {
        let posts = [
            Post(ptitle: "Trial", tagList: [Tag(name: "Cornell"), Tag(name: "Engineering")], cont: "Overheard at Cornell", user_id: 0, like_num: 0),
            Post(ptitle: "Test0", tagList: [Tag(name: "Cornell")], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test1", tagList: [Tag(name: "Cornell")], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test2", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test3", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test4", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test5", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test6", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test7", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test8", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test9", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300),
            Post(ptitle: "Test10", tagList: [], cont: "Another event at Duffield!", user_id: 0, like_num: 21300)
        ]
        return posts
    }
    
    static func getPosts(completion: @escaping ([Post]) -> Void) {
        Alamofire.request(postEndpoint, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                // Mention .convertFromSnakeCase
                // jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let postResponseData = try? jsonDecoder.decode(RawPostResponse.self, from: data) {
                    let postResponse = postResponseData.postArray()
                    print(postResponse.data.count)
                    completion(postResponse.data)
                } else {
                    print("Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getFilters() -> [Tag] {
        var filters: [Tag] = []
        filters.append(Tag(name: "Cornell"))
        filters.append(Tag(name: "Engineering"))
        filters.append(Tag(name: "Arts&Science"))
        filters.append(Tag(name: "PMA"))
        filters.append(Tag(name: "Law"))
        filters.append(Tag(name: "Medicine"))
        filters.append(Tag(name: "Hotel"))
        filters.append(Tag(name: "Architecture"))
        filters.append(Tag(name: "ETC"))
        return filters
    }
    
    static func addUser(username: String, completion: @escaping (UserPostResponse) -> Void) {
        let parameters = [
            "username": username
        ]
        Alamofire.request(addUserEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted , headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
//                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(UserPostResponse.self, from: data) {
                    completion(user)
                } else {
                    print("Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func sendAPost(username: String, userId: Int, content: String, title: String, tags: String, completion: @escaping (CreatePostResponse) -> Void) {
        let endpoint = "http://35.196.182.82/user/" + String(userId) + "/post/"
        print(endpoint)
        let parameters: [String: Any] = [
            "username" : username,
            "content" : content,
            "title" : title,
            "tags" : tags,
            "user_id" : userId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let post = try? jsonDecoder.decode(RawCreatePostResponse.self, from: data) {
                    completion(post.createPostResponse())
                } else {
                    print("Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getAPost(userId: Int, postId: Int, completion: @escaping (Post) -> Void) {
        let endpoint = "http://35.196.182.82/user/" + String(userId) + "/post/" + String(postId) + "/"
        let parameters: [String: Any] = [:]
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let post = try? jsonDecoder.decode(RawCreatePostResponse.self, from: data) {
                    completion(post.createPostResponse().data)
                } else {
                    print("Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteAPost(userId: Int, postId: Int, completion: @escaping (CreatePostResponse) -> Void) -> Bool{
        let endpoint = "http://35.196.182.82/user/" + String(userId) + "/post/" + String(postId)+"/"
        print(endpoint)
        let parameters: [String: Any] = [:]
        var ret = false
        
        Alamofire.request(endpoint, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let post = try? jsonDecoder.decode(RawCreatePostResponse.self, from: data) {
                    completion(post.createPostResponse())
                } else {
                    print("Invalid Response Data")
                }
                ret = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return ret
    }
    
    static func getAUser(userId: Int, completion: @escaping (UserPostResponse) -> Void) {
        let endpoint = "http://35.196.182.82/user/" + String(userId)
        print("Get a user")
        let parameters: [String: Any] = [
            "user_id" : userId
        ]
        
        Alamofire.request(endpoint, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    print(json)
                }
                let jsonDecoder = JSONDecoder()
                if let user = try? jsonDecoder.decode(UserPostResponse.self, from: data) {
                    completion(user)
                } else {
                    print("Invalid Response Data")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func likeAPost(userID: Int, postID: Int, completion: @escaping () -> Void) -> Bool {
        var ret = false
        let endpoint = "http://35.196.182.82/post/" + String(postID) + "/" + String(userID) + "/like/"
        print(endpoint)
        let parameters: [String: Any] = [:]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                ret = true
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return ret
    }
    
    static func unlikeAPost(userID: Int, postID: Int, completion: @escaping () -> Void) -> Bool{
        var ret = false
        let endpoint = "http://35.196.182.82/post/" + String(postID) + "/" + String(userID) + "/unlike/"
        print(endpoint)
        let parameters: [String: Any] = [:]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                ret = true
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return ret
    }
}

struct UserPostResponse: Codable {
    var data: UserResponse
//    var success: Int
}


struct UserResponse: Codable {
    var id: Int
    var posts: [UserPost]
    var user_liked: [UserPost]
    var username: String
}

struct UserPost: Codable {
    var content: String
    var id: Int
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
        return Post(
            id: postData.id,
            title: postData.title,
            tags: taglist,
            content: postData.content,
            username: postData.username,
            likes: postData.likes
        )
    }
}
