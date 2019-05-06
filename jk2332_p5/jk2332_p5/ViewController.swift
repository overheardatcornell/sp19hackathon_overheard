//
//  ViewController.swift
//  A2
//
//  Created by 김지원 on 3/9/19.
//  Copyright © 2019 김지원. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let filterCollectionViewHeight: CGFloat = 50
    let padding: CGFloat = 20
    
    var postCollectionView: UICollectionView!
    var filterCollectionView: UICollectionView!
    
    let postReuseIdentifier = "photoCellReuseIdentifier"
    let filterReuseIdentifier = "filterReuseIdentifier"
    let headerHeight: CGFloat = 30
    var filters : [Tag]! = []
    var activeFilters: [Tag]! = []
    var postArray: [Post]! = []
    var activePosts: [Post]! = []
    
    var profileButton: UIButton = UIButton()
    var addPostButton: UIButton = UIButton()
    
    let userDeviceID = UIDevice.current.identifierForVendor?.uuidString
    public var userID = -1
    
    
    override func viewDidLoad() {
        title = "Overheard At Cornell"
        edgesForExtendedLayout = [] // gets rid of views going under navigation controller
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.631, green: 0.757, blue: 0.506, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        
        //TODO: ADD USER & GET THE USER ID
        RestAPI.addUser(username: userDeviceID!) {
            userResponse in print("Adding User succeeded")
            self.userID = userResponse.data.id
            print(self.userID)
            //TODO: GET POSTS
            RestAPI.getPosts { postsArray in
                self.postArray = postsArray
                self.activePosts = self.postArray
                self.filters = RestAPI.getFilters()
                DispatchQueue.main.async {
                    self.postCollectionView.reloadData()
                }}
        }
        
        //TODO: GET POSTS

        activePosts = postArray
        filters = RestAPI.getFilters()
        
        profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        profileButton.setImage(UIImage(named: "avatar"), for: UIControl.State.normal)
        profileButton.addTarget(self, action: #selector(pushProfileController), for: .touchUpInside)
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        let currWidth = profileBarButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = profileBarButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = profileBarButton
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilterCollectionViewFlowLayout())
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.allowsMultipleSelection = true //this is how we select multiple cells at once
        view.addSubview(filterCollectionView)
        
        postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: PostCollectionViewFlowLayout())
        postCollectionView.translatesAutoresizingMaskIntoConstraints = false
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: postReuseIdentifier)
        postCollectionView.showsHorizontalScrollIndicator = false
        postCollectionView.backgroundColor = .clear
        postCollectionView.contentInset.bottom = postCollectionView.frame.height + 150
        view.addSubview(postCollectionView)
        
        addPostButton = UIButton()
        addPostButton.translatesAutoresizingMaskIntoConstraints = false
        addPostButton.frame = CGRect(x: 0.0, y: 0.0, width: 70, height: 70)
        addPostButton.layer.cornerRadius = addPostButton.layer.frame.size.width/2
        addPostButton.backgroundColor = .white
        addPostButton.layer.masksToBounds = false
        addPostButton.setImage(UIImage(named: "plus"), for: UIControl.State.normal)
        addPostButton.addTarget(self, action: #selector(pushCreatePostController), for: .touchUpInside)
        addPostButton.layer.shadowColor = UIColor.black.cgColor
        addPostButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        addPostButton.layer.shadowRadius = 2
        addPostButton.layer.shadowOpacity = 0.5
        view.addSubview(addPostButton)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        filterCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        filterCollectionView.heightAnchor.constraint(equalToConstant: filterCollectionViewHeight).isActive = true
        
        postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor).isActive = true
        postCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        postCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
//        profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        profileButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        profileButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        profileButton.heightAnchor.constraint(equalToConstant: filterCollectionViewHeight).isActive = true
        
//        addPostButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        addPostButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addPostButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        addPostButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == postCollectionView {
            return activePosts.count
        }
        else {
            return filters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == postCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postReuseIdentifier, for: indexPath) as! PostCollectionViewCell
            let post = activePosts[indexPath.item]
            cell.setup(for: post, user_id: userID)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! TagCollectionViewCell
            let tag = filters[indexPath.item]
            cell.setup(for: tag)
            return cell
        }
    }
    
    //add filter
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return }
            let currentFilter = filters[indexPath.item]
            changeFilter(tag: currentFilter, shouldRemove: false)
//            print(activePosts)
            postCollectionView.reloadData()
        }
        else {
            let currentPost = postArray[indexPath.item]
            pushViewPostController(post: currentPost)
            postCollectionView.reloadData()
        }
    }
    
    //remove filter
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return }
            let currentFilter = filters[indexPath.item]
//            print(activePosts)
            changeFilter(tag: currentFilter, shouldRemove: true)
            postCollectionView.reloadData()
        }
    }
    
    
    func changeFilter(tag: Tag, shouldRemove: Bool = false) {
        if shouldRemove {
            activeFilters.removeAll(where: {$0.tagName == tag.tagName})
        } else {
            print(tag)
            activeFilters.insert(tag, at: 0)
        }
        filterPosts() //now filter the restaurants according to our activeFilters
    }
    
    func filterPosts() {
       let filtered_posts : [Post]!
        filtered_posts = []
        for post in postArray {
            print(post.title)
            var flag : Bool = true;
            for tag in activeFilters{
                if !post.tags.contains(where: {($0.tagName == tag.tagName)}){
                    flag = false;
                }
            }
            if flag{
                filtered_posts.append(post)
            }
        }
        activePosts = filtered_posts
    }
    
    /// Pushes a new "Red Square Arena" view controller to draw red squares
    @objc func pushProfileController(_ target: UIBarButtonItem) {
        let profileViewController = ProfileViewController(userId: userID)
//        profileViewController.sender = target
        profileViewController.name = "My Profile"
        //TODO: TEMPORARY INITIALIZATION
        profileViewController.config()
        navigationController?.pushViewController(profileViewController, animated: true)
        
        // Change title from being default back button text
        let backButton = UIBarButtonItem()
        backButton.title = "Main"
        navigationItem.backBarButtonItem = backButton
        
    }
    
    func pushViewPostController(post : Post) {
        let postViewController = PostViewController()
        postViewController.config(for: post, user_id: userID, username: userDeviceID!)
        navigationController?.pushViewController(postViewController, animated: true)
        
        // Change title from being default back button text
        let backButton = UIBarButtonItem()
        backButton.title = "Main"
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func pushCreatePostController(_ target: UIButton) {
        let createPostViewController = CreatePostViewController(userId: userID)
        createPostViewController.sender = target
        createPostViewController.name = target.currentTitle
        createPostViewController.color = .red
        navigationController?.pushViewController(createPostViewController, animated: true)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Main"
        navigationItem.backBarButtonItem = backButton
    }
    
    
    /// Dismiss current view controller (wrapper for button action)
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    public func getUserId() -> Int{
        return userID
    }
    
    public func reloadData() {
        RestAPI.getPosts { postsArray in
            self.postArray = postsArray
            self.activePosts = self.postArray
            self.filters = RestAPI.getFilters()
            DispatchQueue.main.async {
                self.postCollectionView.reloadData()
            }
        }
    }
}
