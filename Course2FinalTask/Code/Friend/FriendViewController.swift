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
    @IBOutlet weak var followButtonLable: UIButton!
    
    
    var friendIndicator = UIActivityIndicatorView()
    var invisibleView = UIView()
    var lebleOfFollowButton = "1"
    
    var currentUser: User?
    var currentFriend: User?
    var followersToUnfollow = [User]()
    var unwrappedArrayOfFriendPost = [Post]()
    
    static let identifire = "FriendViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUser()
        setLayout()
        getFriend()
        indicator()
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
        setUser()
        setFollowButton()
    }
    
    @objc func tapFollowers(sender: UITapGestureRecognizer) {
        let vc = FollowedByUser()
        show(vc, sender: self)
    }
    // Устанавливаем Юзера на View
    func setUser() {
        guard let friend = currentFriend else {return}
        friendAvatar.image = friend.avatar
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendUserName.text = friend.fullName
        friendFollowersCount.text = String(friend.followedByCount)
        friendFollowingCount.text = String(friend.followsCount)
        title = friend.username
        getFollower()
        setFollowButton()
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        friendCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    
    
    func indicator() {
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .white
        friendIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        friendIndicator.center = self.invisibleView.center
        friendIndicator.startAnimating()
        invisibleView.addSubview(friendIndicator)
        view.addSubview(invisibleView)
    }
    
    func setFollowButton() {
        followButtonLable.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        followButtonLable.layer.cornerRadius = 6
        followButtonLable.setTitle(lebleOfFollowButton, for: .normal)
        
        guard let currentUser = currentUser else {return}
        if let friend = currentFriend {
            
            print(friend.currentUserFollowsThisUser)
            if friend.currentUserFollowsThisUser == true {
                followButtonLable.setTitle("UnFollow", for: .normal)
            } else {
                followButtonLable.setTitle("Follow", for: .normal)
            }
        }
    }
    
    func getFollower() {
        guard let friend = currentFriend else {return}
        user.usersFollowedByUser(with: friend.id, queue: DispatchQueue.global()) { (followers) in
            guard followers != nil else {return}
            DispatchQueue.main.async {
                currentUserFollowers = followers ?? []
                self.invisibleView.isHidden = true
            }
        }
        user.usersFollowingUser(with: friend.id, queue: DispatchQueue.global()) { (following) in
            guard following != nil else {return}
            DispatchQueue.main.async {
                currentUserFollowing = following ?? []
            }
        }
    }
    
    
    //MARK: - FOLLOWERS
    // Передаем на экран подписчики друга массив с Followers или Following
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendFollowing" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Following"
            destination?.friends = currentUserFollowers
        } else if segue.identifier == "friendFollowers" {
            let destination = segue.destination as? FollowedByUser
            destination?.mainTitle = "Followers"
            destination?.friends = currentUserFollowing
        }
    }
    
    //MARK: - FINDPOST
    
    //функция где мы достаем из DataProvider посты для ДРУГА
    func getFriend() {
        if let currentFriend = currentFriend {
            //Если массив пуст, заполняем его
            if unwrappedArrayOfFriendPost.isEmpty {
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayFriendPost) in
                    guard arrayFriendPost != nil else {return}
                    DispatchQueue.main.async {
                        self.unwrappedArrayOfFriendPost = arrayFriendPost ?? []
                        self.invisibleView.isHidden = true
                        self.friendCollectionView.reloadData()
                    }
                }
            } else {
                //Если не пуст, удаляем из него все посты и заливаем новые во избежании ошибки "Index out of range"
                unwrappedArrayOfFriendPost.removeAll()
                post.findPosts(by: currentFriend.id, queue: DispatchQueue.global()) { (arrayFriendPost) in
                    guard arrayFriendPost != nil else {return}
                    DispatchQueue.main.async {
                        self.unwrappedArrayOfFriendPost = arrayFriendPost ?? []
                        self.invisibleView.isHidden = true
                        self.friendCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func followButton(_ sender: Any) {
        
        guard let current = currentFriend else {return}
        if followButtonLable.titleLabel?.text == "Follow" {
            print("Aga")
            user.follow(current.id, queue: DispatchQueue.global()) { (_) in
                DispatchQueue.main.async {
                    self.followButtonLable.setTitle("Unfollow", for: .normal)
                    print("подписаться")
                }
            }
        } else {
            print("Net")
            user.unfollow(current.id, queue: DispatchQueue.global()) { (_) in
                DispatchQueue.main.async {
                    self.followButtonLable.setTitle("Follow", for: .normal)
                    print("отписаться")
                }
            }
        }
    }
}

extension FriendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unwrappedArrayOfFriendPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCell", for: indexPath) as? FriendCollectionViewCell else {return UICollectionViewCell()}
        let aaa = self.unwrappedArrayOfFriendPost[indexPath.row]
        cell.friendImageView.image = aaa.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
}

