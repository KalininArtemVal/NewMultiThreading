//
//  SelectFiltersViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider



class SelectFiltersViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let identifire = "SelectFiltersViewController"
    
    
    let invisibleView = UIView()
    let activityIndicatorCurrent = UIActivityIndicatorView()
    
    var selectedImage: UIImage?
    var filters = [ImageToFilter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator()
        setImage()
        setLayout()
//        findImage()
        collectionView.register(FilterCollectionViewCell.nib(), forCellWithReuseIdentifier: FilterCollectionViewCell.identifire)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func indicator() {
        invisibleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        invisibleView.backgroundColor = .black
        invisibleView.alpha = 0.7
        view.addSubview(invisibleView)
        activityIndicatorCurrent.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        activityIndicatorCurrent.center = self.invisibleView.center
        activityIndicatorCurrent.startAnimating()
        activityIndicatorCurrent.color = .white
        invisibleView.addSubview(activityIndicatorCurrent)
    }
    
    func setLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func setImage() {
        userImage.image = selectedImage
        userImage.contentMode = .scaleAspectFill
    }
}

extension SelectFiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let selectedImage = selectedImage {
            filters = appendImage(with: selectedImage, collection: collectionView, view: invisibleView)
        }
        
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifire, for: indexPath) as? FilterCollectionViewCell else {fatalError("ERRoR!")}
        if let selectedImage = selectedImage {
            filters = appendImage(with: selectedImage, collection: collectionView, view: invisibleView)
                
                let filter = filters[indexPath.row].nameOfFilter ?? "000"
            guard let image = filters[indexPath.row].image else {return cell}
            cell.configue(image: image, filter: filter)
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        userImage.image = filter.image
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SharedViewController {
            guard let image = userImage.image else {return}
            destination.sharedImage = image
            
        }
    }
}
    


extension SelectFiltersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


