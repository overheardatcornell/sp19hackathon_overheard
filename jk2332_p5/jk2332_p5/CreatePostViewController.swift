//
//  ViewController.swift
//  p3
//
//  Created by Matthew Barker on 3/3/18.
//  Copyright © 2018 Walker White. All rights reserved.
//

import UIKit

//protocol CreatePostDelegate {
//    func postAdded(post: Post)
//}


class CreatePostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// The diameter with which to draw the shape
    let shapeSize: CGFloat = 40
    
//    weak var mainViewController: UIViewController?
    var filterCollectionView: UICollectionView!
    let filterReuseIdentifier = "filterReuseIdentifier"
    
    var name: String? = "Create Post"
    var color: UIColor = .black
//    var shapeType: ShapeType? = .square
    
    var sender: UIButton? = nil
    let filterCollectionViewHeight: CGFloat = 50
    
    var titleField: UITextField = UITextField()
    var titleFieldLabel: UILabel = UILabel()
    
    var contentFieldLabel: UILabel = UILabel()
    var contentText: UITextView = UITextView()
    
    
    var localFilters: [Tag]! = []
    var activeFilters: [Tag]! = []
    var user: Int = -1
    
    
    init(userId: Int) {
        super.init(nibName: nil, bundle: nil)
        user = userId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = name
        view.backgroundColor = .white
        
        // Save Button
        
        let saveButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(savePressed))
        navigationItem.rightBarButtonItem = saveButton
        
        // Create Elements
        
        titleFieldLabel.text = "Post Title:"
        titleFieldLabel.textAlignment = .right
        titleFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleFieldLabel)
        
//        titleField.text = name
        titleField.borderStyle = .roundedRect
        titleField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleField)
        
        contentFieldLabel.text = "Content:"
        contentFieldLabel.textAlignment = .right
        contentFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentFieldLabel)
        
        contentText.text = "Write here"
        contentText.layer.cornerRadius = 4
        contentText.layer.masksToBounds = false
        contentText.layer.borderColor = UIColor.black.cgColor
        contentText.layer.borderWidth = 1.0;
        contentText.isEditable = true
        contentText.backgroundColor = .white
        contentText.font = UIFont.systemFont(ofSize: 16)
        contentText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentText)
    
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: FilterCollectionViewFlowLayout())
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.allowsMultipleSelection = true //this is how we select multiple cells at once
        view.addSubview(filterCollectionView)
        
        localFilters.append(Tag(name: "Cornell"))
        localFilters.append(Tag(name: "Engineering"))
        localFilters.append(Tag(name: "Arts&Science"))
        localFilters.append(Tag(name: "PMA"))
        localFilters.append(Tag(name: "Law"))
        localFilters.append(Tag(name: "Medicine"))
        localFilters.append(Tag(name: "Hotel"))
        localFilters.append(Tag(name: "Architecture"))
        localFilters.append(Tag(name: "ETC"))
        
        setUpConstraints()
        
        
        
    }
    
    func setUpConstraints(){
        let inset: CGFloat = 20
        titleFieldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset).isActive = true
        titleFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset).isActive = true
        titleFieldLabel.widthAnchor.constraint(equalToConstant: titleFieldLabel.intrinsicContentSize.width).isActive = true
        
        titleField.leadingAnchor.constraint(equalTo: titleFieldLabel.trailingAnchor, constant: inset).isActive = true
        titleField.centerYAnchor.constraint(equalTo: titleFieldLabel.centerYAnchor).isActive = true
        titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset).isActive = true
        titleField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        filterCollectionView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 30).isActive = true
        filterCollectionView.heightAnchor.constraint(equalToConstant: filterCollectionViewHeight).isActive = true
        
        contentFieldLabel.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor).isActive = true
        contentFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset).isActive = true
        contentFieldLabel.widthAnchor.constraint(equalTo: titleFieldLabel.widthAnchor)
        contentFieldLabel.heightAnchor.constraint(equalTo: titleField.heightAnchor).isActive = true
        
        contentText.topAnchor.constraint(equalTo: contentFieldLabel.bottomAnchor, constant: 5).isActive = true
        contentText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset).isActive = true
        contentText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset).isActive = true
        contentText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inset).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localFilters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! TagCollectionViewCell
        let tag = localFilters[indexPath.item]
        cell.setup(for: tag)
        return cell
    }

    //remove filter
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return }
            let currentFilter = localFilters[indexPath.item]
            changeFilter(tag: currentFilter, shouldRemove: false)
//            filterCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return }
            let currentFilter = localFilters[indexPath.item]
            //            print(activePosts)
            changeFilter(tag: currentFilter, shouldRemove: true)
//            filterCollectionView.reloadData()
        }
    }

    func changeFilter(tag: Tag, shouldRemove: Bool = false) {
        if shouldRemove {
            activeFilters.removeAll(where: {$0.tagName == tag.tagName})
        } else {
            activeFilters.insert(tag, at: 0)
        }
    }
    
    
    /// If new arena title valid, save name and dismiss view controller
    @objc func savePressed() {
        
        // Data Validation
        
        if let newName = titleField.text, let newContent = contentText.text, newName != "" && newContent != "" {
//            let createdPost = Post(ptitle: newName, tagList: localFilters, cont: newContent, user_id: 0, like_num: 0)
//            delegate?.postAdded(post: createdPost)
            var parsed_tag = ""
            for tag in activeFilters {
                parsed_tag = parsed_tag + tag.tagName + ","
            }
            if (parsed_tag != ""){
                parsed_tag.removeLast()
            }
//            print(user)
            RestAPI.sendAPost(username: (UIDevice.current.identifierForVendor?.uuidString)!, userId: user, content: newContent, title: newName, tags: parsed_tag) {
                postResponse in print("Posting succeeded")
                
                if self != self.navigationController?.viewControllers.first {
                    // Can pop to previous view controller
                    self.navigationController?.popViewController(animated: true)
                    print("reload")
                    guard let vc = self.navigationController?.visibleViewController as? ViewController else {
                        print("reloadfail")
                        return }
                    vc.reloadData()
                } else {
                    // Must be in modal with one root view controller, so dismiss
                    self.dismiss(animated: true)
                    guard let vc = self.navigationController?.visibleViewController as? ViewController else {
                        print("reloadfail")
                        return }
                    vc.reloadData()
                }
            }
            
        }
            // Present Error
        else {
            let title = "Invalid Arena Name!"
            let message = "Please fill in the title and the content."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Sheesh...", style: .cancel, handler: { (_) in
                self.titleField.text = self.name
                self.titleField.becomeFirstResponder()
            }))
            present(alertController, animated: true)
            
            // Dismiss based on context.
            if self != navigationController?.viewControllers.first {
                // Can pop to previous view controller
                navigationController?.popViewController(animated: true)
                print("reload")
                guard let vc = navigationController?.visibleViewController as? ViewController else {
                    print("reloadfail")
                    return }
                vc.reloadData()
            } else {
                // Must be in modal with one root view controller, so dismiss
                dismiss(animated: true)
                guard let vc = navigationController?.visibleViewController as? ViewController else {
                    print("reloadfail")
                    return }
                vc.reloadData()
            }
        }
    }
    
    /// Dismiss current view controller (wrapper for button action)
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    
}




