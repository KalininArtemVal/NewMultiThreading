//
//  FriendCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 29.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

//MARK: - Collection View Cell of Friend (Ячейка коллекции ДРУГА)

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImageView: UIImageView!
    
    static let identifire = "friendCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configue(with image: UIImage) {
        friendImageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FriendCollectionViewCell", bundle: nil)
    } 
}


