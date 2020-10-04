//
//  NewPostViewController.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 25.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

let photosData = DataProviders.shared.photoProvider
let photos = photosData.photos()


class NewPostViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        collectionView.register(NewPostsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewPostsCollectionViewCell.identifire)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    
}
//MARK: - Коллекция
extension NewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewPostsCollectionViewCell.identifire, for: indexPath) as? NewPostsCollectionViewCell else {fatalError("hogeCell not registered.")}
        let post = photos[indexPath.row]
        cell.configue(with: post)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            guard let vc = storyboard?.instantiateViewController(identifier: SelectFiltersViewController.identifire) as? SelectFiltersViewController else { return }
            let image = photos[indexPath.row]
            vc.selectedImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
}



//MARK: - Констрейнты
extension NewPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/3.0, height: UIScreen.main.bounds.size.width/3.0)
    }
    
}
