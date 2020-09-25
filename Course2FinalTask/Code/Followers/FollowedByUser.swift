//
//  Followers.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 23.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

//MARK: - Followed/Following (Подписки/Подписчики Текущего пользователя)
let followedByUser = currentUserFollowers
let followingUser = currentUserFollowing


//MARK: - Table View (Таблица)
class FollowedByUser: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var friends: [User]?
    var mainTitle = "SomeTitle"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mainTitle
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FollowedByUser: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friend = friends?[indexPath.row] else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "followedCell", for: indexPath) as! FollowedByUserTableViewCell
        cell.userName.text = friend.fullName
        cell.userPhoto.image = friend.avatar
        cell.userPhoto.layer.cornerRadius = cell.userPhoto.frame.size.width / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriend" {
            let destination = segue.destination as? FriendViewController
            if let friend = friends?[tableView.indexPathForSelectedRow!.row] {
                destination?.currentFriend = friend
            }
        }
    }
}
