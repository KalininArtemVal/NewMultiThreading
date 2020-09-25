//
//  NewPostsCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 25.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class NewPostsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newPhotoImage: UIImageView!
    
    static let identifire = "NewPostsCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configue(with image: UIImage) {
        newPhotoImage.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewPostsCollectionViewCell", bundle: nil)
    }

}
