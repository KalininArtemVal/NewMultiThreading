//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 19.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - Followers
var youAreFollowed = [User]()


//MARK: - вызываем post

var feedReturn = [Post]()
var usersLikesPostArray = [User]()
let post = DataProviders.shared.postsDataProvider
var lookingUser: User?

var feedReturnWithOutNill = [Post]()
let queueUtility = DispatchQueue.global(qos: .utility)

//MARK: - Feed (Лента)
class FeedViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    var unwrapdeArrayOfLikesByUsers = [User]()
    var userOfCurrentPost: User?
    var following = [User]()
    var follwed = [User]()
    var curUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeed()
        getUser()
        setLayout()
        activIndicator()
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.register(FeedCollectionViewCell.nib(), forCellWithReuseIdentifier: FeedCollectionViewCell.identifire)
        feedCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFeed()
        feedCollectionView.reloadData()
    }
    
    
    //вытаскиваем данные
    func getFeed() {
        post.feed(queue: queueUtility) { (feedReturn) in
            guard feedReturn != nil else {return}
            DispatchQueue.main.async {
                self.activeIndicator.isHidden = true
                feedReturnWithOutNill = feedReturn ?? []
                self.feedCollectionView.reloadData()
            }
        }
    }
    
    func activIndicator() {
        self.activeIndicator.isHidden = false
        activeIndicator.startAnimating()
        
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        feedCollectionView.collectionViewLayout = layout
    }
    
    //вытаскиваем текущего пользователя
    func getUser() {
        user.currentUser(queue: DispatchQueue.global()) { (getuser) in
            guard getuser != nil else {return}
            self.curUser = getuser
            guard let currentUser = self.curUser else {return}
            //вытаскиваем подписчиков текущего пользователя
            user.usersFollowedByUser(with: currentUser.id, queue: DispatchQueue.global()) { (users) in
                guard users != nil else {return}
                DispatchQueue.main.async {
                    youAreFollowed = users ?? []
                }
            }
        }
    }
}




extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedReturnWithOutNill.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCollectionViewCell else {fatalError("ERRoR!")}
        let post = feedReturnWithOutNill[indexPath.item]
        //Устанавлиывем дату
        let dateFormatter = DateFormatter()
        let createTime = post.createdTime
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        let time = dateFormatter.string(from: createTime)
        
        if post.currentUserLikesThisPost == true {
            cell.imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            cell.imageHeartOfLike.tintColor = .systemBlue
        } else {
            cell.imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            cell.imageHeartOfLike.tintColor = .lightGray
        }
        cell.userName?.text = post.authorUsername
        cell.countOfLikes?.text = String(post.likedByCount)
        cell.descriptionTextLable?.text = post.description
        cell.dateOfPublishing?.text = time
        cell.userAvatar?.image = post.authorAvatar
        cell.userAvatar?.layer.cornerRadius = (cell.userAvatar?.frame.size.width)! / 2
        cell.postImage?.image = post.image
        cell.currentFriend?.id = post.author
        cell.currentPost = post
        cell.delegate = self
        return cell
    }
}


extension FeedViewController: UICollectionViewDelegateFlowLayout, CellDelegate {
    
    // MARK: - Обновляем ленту
    func updateFeed() {
        DispatchQueue.global().async {
            self.getUser()
            self.getFeed()
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
        }
        
    }
    
    
    // MARK: - didTap on Likes (Переход по тапу на кол-во Лайков)
    func didTapOnLikes(in cell: UICollectionViewCell, currentPost: Post) {
        //Удаляем прежде загруженных пользователей с прошлой публикации
        self.unwrapdeArrayOfLikesByUsers.removeAll()
        post.usersLikedPost(with: currentPost.id, queue: DispatchQueue.global()) { (array) in
            guard array != nil else {return}
            
            DispatchQueue.main.async {
                self.unwrapdeArrayOfLikesByUsers = array ?? []
                self.getLikes()
                self.feedCollectionView.reloadData()
                
            }
        }
    }
    //Функция для перехода на списсок юзеров поставивших лайк
    func getLikes() {
        if #available(iOS 13.0, *) {
            guard let friendViewController = self.storyboard?.instantiateViewController(identifier: "FollowedByUser") as? FollowedByUser else { return }
            DispatchQueue.global().async {
                friendViewController.mainTitle = "Likes"
                friendViewController.friends = self.unwrapdeArrayOfLikesByUsers
                
                DispatchQueue.main.async {
                    self.show(friendViewController, sender: self)
                }
            }
        }
    }
    
    // MARK: - didTap on Avatar (Переход по тапу на Аватар/Имя)
    func didTap(OnAvatarIn cell: UICollectionViewCell, currentPost: Post) {
        var changeFollow = ""
        //Вытаскиваем follwed
        guard let current = curUser else {return}
        user.usersFollowedByUser(with: current.id, queue: DispatchQueue.global()) { (followers) in
            guard followers != nil else {return}
            self.follwed = followers ?? []
            for user in self.follwed {
                if user.id == currentPost.author {
                    self.userOfCurrentPost = user
                    changeFollow = "Unfollow"
                }
            }
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    guard let secondViewController = self.storyboard?.instantiateViewController(identifier: "FriendViewController") as? FriendViewController else { return }
                    
                    secondViewController.lebleOfFollowButton = changeFollow
                    secondViewController.currentFriend = self.userOfCurrentPost
                    self.show(secondViewController, sender: self)
                }
            }
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.size.width/1.0, height: 600)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
