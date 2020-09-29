//
//  FilterClass.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

//MARK: - Класс фильтров
class UseFilter: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    var nameFilter: String?
    var parametr: [String: Any]
    let context = CIContext()
    var outPutImage = UIImage()
    
    init(nameFilter: String?, parametr: [String: Any]) {
        self.nameFilter = nameFilter
        self.parametr = parametr
    }
    
    override func main() {
        //функция для добавления фильтра
        guard let filter = CIFilter(name: nameFilter ?? "", parameters: parametr),
            let outputImage = filter.outputImage,
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
        outPutImage = UIImage(cgImage: cgiImage)
    }
}


let queue = OperationQueue()

//let queue2 = OperationQueue()

var newImage1 = UIImage()
var newImage2 = UIImage()
var newImage3 = UIImage()
var newImage4 = UIImage()
var newImage5 = UIImage()

//функции по выбору фильтров
//1 Noir
public func doNoirFilter(originalImage: UIImage, collection: UICollectionView, view: UIView) -> UIImage? {
    
    guard let ciimage = CIImage(image: originalImage) else {return nil}
    let useeFilter = UseFilter(nameFilter: "CIPhotoEffectNoir", parametr: [kCIInputImageKey: ciimage])
    queue.addOperations([useeFilter], waitUntilFinished: false)
    useeFilter.completionBlock = {
        DispatchQueue.main.async {
            newImage1 = useeFilter.outPutImage
            collection.reloadData()
            view.isHidden = true
        }
    }
    return newImage1
}
//2 Fade
public func doFadeFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
    
    guard let ciimage = CIImage(image: originalImage) else {return nil}
    let useeFilter = UseFilter(nameFilter: "CIPhotoEffectFade", parametr: [kCIInputImageKey: ciimage])
    queue.addOperations([useeFilter], waitUntilFinished: false)
    useeFilter.completionBlock = {
        DispatchQueue.main.async {
            newImage2 = useeFilter.outPutImage
            collection.reloadData()
        }
    }
    return newImage2
}
//3 Sepia
public func doSepiaFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
    
    guard let ciimage = CIImage(image: originalImage) else {return nil}
    let useeFilter = UseFilter(nameFilter: "CISepiaTone", parametr: [kCIInputImageKey: ciimage])
    queue.addOperations([useeFilter], waitUntilFinished: false)
    useeFilter.completionBlock = {
        DispatchQueue.main.async {
            newImage3 = useeFilter.outPutImage
            collection.reloadData()
        }
    }
    return newImage3
}
//4 Blur
public func doTonalFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
    
    guard let ciimage = CIImage(image: originalImage) else {return nil}
    let useeFilter = UseFilter(nameFilter: "CIPhotoEffectTonal", parametr: [kCIInputImageKey: ciimage])
    queue.addOperations([useeFilter], waitUntilFinished: false)
    useeFilter.completionBlock = {
        DispatchQueue.main.async {
            newImage4 = useeFilter.outPutImage
            collection.reloadData()
        }
    }
    return newImage4
}

//5 Transfer
public func doTransferFilter(originalImage: UIImage, collection: UICollectionView) -> UIImage? {
    guard let ciimage = CIImage(image: originalImage) else {return nil}
    let useeFilter = UseFilter(nameFilter: "CIPhotoEffectTransfer", parametr: [kCIInputImageKey: ciimage])
    queue.addOperations([useeFilter], waitUntilFinished: false)
    useeFilter.completionBlock = {
        DispatchQueue.main.async {
            newImage5 = useeFilter.outPutImage
            collection.reloadData()
        }
    }
    return newImage5
}


