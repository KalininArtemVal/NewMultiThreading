//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 20.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - вызываем user
let user = DataProviders.shared.usersDataProvider
var asyncCurrentUser: User?

var followedByUser = [User]()
var followingUser = [User]()
//MARK: - Profile of Сurrent User (Страница текущего пользователя)
class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imageLable: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var countOfFollowers: UILabel!
    @IBOutlet weak var countOfFollowing: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let activityIndicatorCurrent = UIActivityIndicatorView()
    let invisibleView = UIView()
    var animatoin: UIViewPropertyAnimator!
    
    var postsOfCurrentUser = [Post]()
    var followingThisUser = [User]()
    var followedByThisUser = [User]()
    
    
    
    func setArrayOfCurrentPost() {
        if let asyncCurrentUser = asyncCurrentUser {
            post.findPosts(by: asyncCurrentUser.id, queue: DispatchQueue.global()) { (postsOfCurrentUser) in
                guard postsOfCurrentUser != nil else {return}
                DispatchQueue.main.async {
                    self.postsOfCurrentUser = postsOfCurrentUser ?? []
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    var arrayOfCurrentPostUnwrapped = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator()
        setLayout()
        setCurrentUser()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewProfileCollectionViewCell.nib(), forCellWithReuseIdentifier: NewProfileCollectionViewCell.identifire)
        collectionView.reloadData()
        self.collectionView.alwaysBounceVertical = true
        self.view.addSubview(invisibleView)
    }
    
    func indicator() {
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .white
        
        activityIndicatorCurrent.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        activityIndicatorCurrent.center = self.invisibleView.center
        activityIndicatorCurrent.startAnimating()
        invisibleView.addSubview(activityIndicatorCurrent)
    }
    
    private func setCurrentUser() {
        user.currentUser(queue: DispatchQueue.global()) { (user) in
            guard user != nil else {return}
            DispatchQueue.main.async {
                
                asyncCurrentUser = user
                if let newMan = asyncCurrentUser {
                    self.imageLable.image = newMan.avatar
                    self.imageLable.layer.cornerRadius = self.imageLable.frame.size.width / 2
                    self.nameLable.text = newMan.fullName
                    let followers = newMan.followedByCount
                    let followedBy = newMan.followsCount
                    self.countOfFollowers.text = String(followers)
                    self.countOfFollowing.text = String(followedBy)
                    self.setArrayOfCurrentPost()
                    self.getFollowers()
                    
                }
            }
            
        }
    }
    
    
    func getFollowers() {
        guard let currentUser = asyncCurrentUser else {return}
        user.usersFollowedByUser(with: currentUser.id, queue: DispatchQueue.global()) { (users) in
            guard users != nil else {return}
            DispatchQueue.main.async {
                self.followedByThisUser = users ?? []
                followedByUser = users ?? []
                self.invisibleView.isHidden = true
                self.activityIndicatorCurrent.stopAnimating()
                return
            }
        }
        
        user.usersFollowingUser(with: currentUser.id, queue: DispatchQueue.global()) { (users) in
            guard users != nil else {return}
            DispatchQueue.main.async {
                self.followingThisUser = users ?? []
                followingUser = users ?? []
                return
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect = self.view.frame
        rect.origin.y =  -scrollView.contentOffset.y
        self.view.frame = rect
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followers" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Followers"
            destination?.friends = followingThisUser
        } else if segue.identifier == "following" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Following"
            destination?.friends = followedByThisUser
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsOfCurrentUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as? NewProfileCollectionViewCell else {fatalError("hogeCell not registered.")}
        let post = postsOfCurrentUser[indexPath.row]
        cell.configue(with: post.image)
        return cell
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
    
}
