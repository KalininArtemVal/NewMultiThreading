//
//  SharedViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 27.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class SharedViewController: UIViewController {
    
    @IBOutlet weak var sharedImageView: UIImageView!
    @IBOutlet weak var sharedTextField: UITextField!
    
    static let identifire = "SharedViewController"
    
    var sharedImage = UIImage()
    var sharedPost: Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        setSharedImage()
    }
    
    func setSharedImage() {
        sharedImageView.image = sharedImage
        
    }
    
    @IBAction func unwindToFeed( _ sender: UIStoryboardSegue) {
        print("Goo")
    }
    
    @IBAction func shredButton(_ sender: Any) {
        print("hhh")
        sharedTextField.text = ""
        dismiss(animated: true, completion: nil)
        
        
        post.newPost(with: sharedImage, description: sharedTextField.text ?? "", queue: DispatchQueue.global()) { (post) in
            guard post != nil else {return}
            DispatchQueue.main.async {
                self.sharedPost = post
            }
        }
        
    }
}
