//
//  FriendViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 28.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//Подписчики followed
var currentUserFollowers = [User]()
//Подписчики following
var currentUserFollowing = [User]()

//MARK: - View Controller of Friend (экран ДРУГА)

class FriendViewController: UIViewController {
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendUserName: UILabel!
    @IBOutlet weak var friendFollowersCount: UILabel!
    @IBOutlet var friendFollowingCount: UILabel!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    
    var currentFriend: User?
    var unwrappedArrayOfFriendPost = [Post]()

    
    static let identifire = "FriendViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
        setLayout()
        friendCollectionView.reloadData()
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        friendCollectionView.register(FriendCollectionViewCell.nib(), forCellWithReuseIdentifier: FriendCollectionViewCell.identifire)
    }
    
    //MARK: - Make Scroll (Делаем скрол)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect = self.view.frame
        rect.origin.y =  -scrollView.contentOffset.y
        self.view.frame = rect
    }
    
    override func viewWillAppear(_ animated: Bool) {
        friendCollectionView.reloadData()
    }
    
    @objc func tapFollowers(sender: UITapGestureRecognizer) {
        let vc = FollowedByUser()
        show(vc, sender: self)
    }
    
    func setUser() {
        guard let friend = currentFriend else {return}
        friendAvatar.image = friend.avatar
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendUserName.text = friend.fullName
        friendFollowersCount.text = String(friend.followedByCount)
        friendFollowingCount.text = String(friend.followsCount)
        title = friend.username
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        friendCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendFollowing", let currentUser = asyncCurrentUser {
            let destination = segue.destination as? FollowedByUser
            user.usersFollowedByUser(with: currentUser.id, queue: DispatchQueue.global()) { (currentUserFollowers) in
                guard currentUserFollowers != nil else {return}
            }
            destination?.mainTitle = "Following"
            destination?.friends = currentUserFollowers
        } else if segue.identifier == "friendFollowers", let currentUser = asyncCurrentUser {
            let destination = segue.destination as? FollowedByUser
            user.usersFollowingUser(with: currentUser.id, queue: DispatchQueue.global()) { (currentUserFollowing) in
                guard currentUserFollowing != nil else {return}
            }
            destination?.mainTitle = "Followers"
            destination?.friends = currentUserFollowing
        }
    }
}

extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let currentFriend = currentFriend {
            let arrayOfCurrentFriendPost = [Post]()
            post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayOfCurrentFriendPost) in
                guard arrayOfCurrentFriendPost != nil else {return}
                
            }
            for i in arrayOfCurrentFriendPost {
                unwrappedArrayOfFriendPost.append(i)
            }
        }
        return unwrappedArrayOfFriendPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell else {return UICollectionViewCell()}
        if unwrappedArrayOfFriendPost.isEmpty {
            if let currentFriend = currentFriend {
                let arrayOfCurrentFriendPost = [Post]()
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayOfCurrentFriendPost) in
                    guard arrayOfCurrentFriendPost != nil else {return}
                }
                let currentFriend = arrayOfCurrentFriendPost[indexPath.row]
                    cell.friendImageView.image = currentFriend.image
                    return cell
                
            }
        } else {
            unwrappedArrayOfFriendPost.removeAll()
            if let currentFriend = currentFriend {
                let arrayOfCurrentFriendPost = [Post]()
                    
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayOfCurrentFriendPost) in
                    guard arrayOfCurrentFriendPost != nil else {return}
                }
                let currentFriend = arrayOfCurrentFriendPost[indexPath.row]
                    cell.friendImageView.image = currentFriend.image
                    return cell
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
}

