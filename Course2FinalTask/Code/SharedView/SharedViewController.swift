//
//  SharedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 27.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {
    
    @IBOutlet weak var sharedImageView: UIImageView!
    @IBOutlet weak var sharedTextField: UITextField!
    
    static let identifire = "SharedViewController"
    
    var sharedImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSharedImage()
//        sharedImageView.image = sharedImage
    }
    
    func setSharedImage() {
//        guard let image = sharedImage else {return}
        
        sharedImageView.image = sharedImage
    }
}
