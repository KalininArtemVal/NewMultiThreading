//
//  FilterCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var filterLable: UILabel!
    @IBOutlet weak var filterImage: UIImageView!
    static let identifire = "FilterCollectionViewCell"
    let activityIndicatorCurrent = UIActivityIndicatorView()
    static var indicatorIsActive = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterImage.contentMode = .scaleAspectFit
    }
    
    
    public func configue(image: UIImage, filter: String) {
        filterImage.image = image
        filterLable.text = filter
        filterImage.contentMode = .scaleAspectFit
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FilterCollectionViewCell", bundle: nil)
    }
}
