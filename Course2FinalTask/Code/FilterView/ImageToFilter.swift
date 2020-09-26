//
//  File.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//структура
struct ImageToFilter {
    var image: UIImage?
    var nameOfFilter: String?
}




func appendImage(with image: UIImage) -> [ImageToFilter] {
    
    var arrayWithFilter = [ImageToFilter]()
    let useFilter = UseFilter()
    
    let newImage1 = useFilter.doNoirFilter(originalImage: image)
    let first = ImageToFilter(image: newImage1, nameOfFilter: "Noir")
    arrayWithFilter.append(first)
    
    let newImage2 = useFilter.doFadeFilter(originalImage: image)
    let second = ImageToFilter(image: newImage2, nameOfFilter: "Fade")
    arrayWithFilter.append(second)
    
    let newImage3 = useFilter.doSepiaFilter(originalImage: image)
    let third = ImageToFilter(image: newImage3, nameOfFilter: "Sepia")
    arrayWithFilter.append(third)
    
    let newImage4 = useFilter.doTonalFilter(originalImage: image)
    let four = ImageToFilter(image: newImage4, nameOfFilter: "Tonal")
    arrayWithFilter.append(four)
    
    let newImage5 = useFilter.doTransferFilter(originalImage: image)
    let five = ImageToFilter(image: newImage5, nameOfFilter: "Transfer")
    arrayWithFilter.append(five)
    
    return arrayWithFilter
    
}
