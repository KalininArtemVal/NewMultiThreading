//
//  ShareViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 02.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//
import UIKit
import DataProvider

class SharedViewController: UIViewController {
    
    @IBOutlet weak var sharedImageView: UIImageView!
    @IBOutlet weak var sharedTextField: UITextField!
    @IBOutlet weak var sharedLable: UIBarButtonItem!
    
    
    static let identifire = "SharedViewController"
    
    var sharedImage = UIImage()
    var sharedPost: Post?
    var descriptionText = ""

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
        descriptionText = sharedTextField.text ?? ""
        print(descriptionText)
        post.newPost(with: sharedImage, description: sharedTextField.text ?? "", queue: DispatchQueue.global()) { (_) in  }
        print("опубликовал")
        
        let alertController = UIAlertController(title: "Пост опубликован", message: "Вы можете его найти в своих публикациях", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
        sharedTextField.text = ""
    }
}
