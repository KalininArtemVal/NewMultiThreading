//
//  FeedCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 22.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - CellDelegate (для переходов по тапу на аватра/имя/лайки)
protocol CellDelegate: UIViewController {
    func didTap(OnAvatarIn cell: UICollectionViewCell, currentPost: Post)
    func didTapOnLikes(in cell: UICollectionViewCell, currentPost: Post)
}


//MARK: - Cell Feed (Ячейка коллекции)
class FeedCollectionViewCell: UICollectionViewCell {
    
    
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var userAvatar: UIImageView?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dateOfPublishing: UILabel?
    @IBOutlet weak var postImage: UIImageView?
    @IBOutlet weak var countOfLikes: UILabel!
    @IBOutlet weak var heartOfLike: UIButton?
    @IBOutlet weak var descriptionTextLable: UILabel?
    @IBOutlet weak var imageHeartOfLike: UIImageView!
    @IBOutlet weak var bigHeart: UIImageView!
    
    static let identifire = "feedCell"
    
    var currentFriend: User?
    var currentPost: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTaps()
    }
    
    
    
    // MARK: - Set Tap Recognizer
    func setTaps() {
        //Тап на количество лайков
        let touchOnCountOfLikes = UITapGestureRecognizer(target: self, action: #selector(tapLike(sender:)))
        countOfLikes?.isUserInteractionEnabled = true
        countOfLikes?.addGestureRecognizer(touchOnCountOfLikes)
        
        //Тап на аватар и имя
        let touchUserAvatar = UITapGestureRecognizer(target: self, action: #selector(tapAvatar(sender:)))
        userAvatar?.isUserInteractionEnabled = true
        userAvatar?.addGestureRecognizer(touchUserAvatar)
        
        //Тап на имя
        let touchOnUserName = UITapGestureRecognizer(target: self, action: #selector(tapAvatar(sender:)))
        userName?.isUserInteractionEnabled = true
        userName?.addGestureRecognizer(touchOnUserName)
        
        //Ставим лайк от маленького сердца
        let touchLitleHeart = UITapGestureRecognizer(target: self, action: #selector(tapHeart(sender:)))
        touchLitleHeart.numberOfTapsRequired = 1
        bigHeart.isHidden = true
        imageHeartOfLike?.isUserInteractionEnabled = true
        imageHeartOfLike?.addGestureRecognizer(touchLitleHeart)
        
        //устанавливаем большое сердце
        let touchPost = UITapGestureRecognizer(target: self, action: #selector(tapPost(sender:)))
        touchPost.numberOfTapsRequired = 2
        bigHeart.isHidden = true
        postImage?.isUserInteractionEnabled = true
        postImage?.addGestureRecognizer(touchPost)
    }
    
    //функция тап лайк
    @objc func tapLike(sender: UITapGestureRecognizer) {
        let vc = FeedCollectionViewCell()
        guard let currentPost = currentPost else {return}
        delegate?.didTapOnLikes(in: vc, currentPost: currentPost)
    }
    
    //функция тап на сердечко
    @objc func tapHeart(sender: UITapGestureRecognizer) {
        let voice = 1
        guard var countLike = currentPost?.likedByCount else {return}
        if currentPost?.currentUserLikesThisPost == false {
            currentPost?.currentUserLikesThisPost = true
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .systemBlue
//            countLike += voice
            countOfLikes?.text = String(countLike)
            currentPost?.likedByCount = countLike
            guard let currentPost = currentPost else {return}
            post.likePost(with: currentPost.id, queue: DispatchQueue.global()) { (_) in }
        } else {
            currentPost?.currentUserLikesThisPost = false
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .lightGray
//            countLike -= voice
            currentPost?.likedByCount = countLike
            countOfLikes?.text = String(countLike)
            print("Unliked post")
            guard let currentPost = currentPost else {return}
            post.unlikePost(with: currentPost.id, queue: DispatchQueue.global()) { (_) in }
        }
    }
    
    //функция тап на Аватар
    @objc func tapAvatar(sender: UITapGestureRecognizer) {
        let vc = FeedCollectionViewCell()
        guard let currentPost = currentPost else {return}
        delegate?.didTap(OnAvatarIn: vc, currentPost: currentPost)
    }
    
    //функция тап на сам пост
    @objc func tapPost(sender: UITapGestureRecognizer) {
        let voice = 1
        guard var countLike = currentPost?.likedByCount else {return}
        if currentPost?.currentUserLikesThisPost == false {
            currentPost?.currentUserLikesThisPost = true
            bigHeart.isHidden = false
            imageHeartOfLike.image = #imageLiteral(resourceName: "like")
            imageHeartOfLike.tintColor = .systemBlue
            countLike += voice
            currentPost?.likedByCount = countLike
            countOfLikes?.text = String(countLike)
            
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.values = [0.0, 1.0, 1.0, 0.0]//.map { NSNumber(value: $0) }
            animation.keyTimes = [0.0, 0.1, 0.3, 0.6]
            animation.duration = 0.6
            animation.timingFunctions = [
                            CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear),
                            CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear),
                            CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
                        ]
            bigHeart.layer.add(animation, forKey: nil)
            bigHeart.layer.opacity = 0.0
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FeedCollectionViewCell", bundle: nil)
    }
    
    
}
