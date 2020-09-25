//
//  NewProfileCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 24.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

//MARK: - Collection View Cell of Current User (Ячейка коллекции Текущего пользователя)
class NewProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifire = "profileCell"
    
    public func configue(with image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NewProfileCollectionViewCell", bundle: nil)
    }
}
