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
        
        post.newPost(with: sharedImage, description: sharedTextField.text ?? "", queue: DispatchQueue.global()) { (_) in  }
        print("опубликовал")
        
        let alertController = UIAlertController(title: "Пост опубликован", message: "Вы можете его найти в своих публикациях", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
