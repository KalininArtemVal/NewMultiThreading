//
//  File.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - Структура Фото для фильтра
struct ImageToFilter {
    var image: UIImage?
    var nameOfFilter: String?
}

//MARK: - Добавить фото в массив
// Функция добавления обработанных фотографий в массив для коллекции
func appendImage(with image: UIImage, collection: UICollectionView, view: UIView) -> [ImageToFilter] {
    
    var arrayWithFilter = [ImageToFilter]()
    
    let newImage1 = doNoirFilter(originalImage: image, collection: collection, view: view)
    let first = ImageToFilter(image: newImage1, nameOfFilter: "Noir")
    arrayWithFilter.append(first)
    
    let newImage2 = doFadeFilter(originalImage: image, collection: collection)
    let second = ImageToFilter(image: newImage2, nameOfFilter: "Fade")
    arrayWithFilter.append(second)
    
    let newImage3 = doSepiaFilter(originalImage: image, collection: collection)
    let third = ImageToFilter(image: newImage3, nameOfFilter: "Sepia")
    arrayWithFilter.append(third)
    
    let newImage4 = doTonalFilter(originalImage: image, collection: collection)
    let four = ImageToFilter(image: newImage4, nameOfFilter: "Tonal")
    arrayWithFilter.append(four)
    
    let newImage5 = doTransferFilter(originalImage: image, collection: collection)
    let five = ImageToFilter(image: newImage5, nameOfFilter: "Transfer")
    arrayWithFilter.append(five)
    
    return arrayWithFilter
    
}
