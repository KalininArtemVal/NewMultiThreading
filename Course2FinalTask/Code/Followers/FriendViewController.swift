//
//  FriendViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 25.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FriendViewController: UIViewController {
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var countOfFollowers: UILabel!
    @IBOutlet weak var countOfFollowing: UILabel!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    

    var friend: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFriend()
    }
    
    func setFriend() {
        friendAvatar.image = friend?.avatar
        friendAvatar.layer.cornerRadius = friendAvatar.frame.size.width / 2
        friendName.text = friend?.fullName
        countOfFollowers.text = String(friend?.followedByCount ?? 0)
        countOfFollowing.text = String(friend?.followsCount ?? 0)
    }

}
