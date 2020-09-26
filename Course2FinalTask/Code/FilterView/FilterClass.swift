//
//  FilterClass.swift
//  Course2FinalTask
//
//  Created by Калинин Артем Валериевич on 26.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class UseFilter {
    
    let context = CIContext()
    //функция для добавления фильтра
    
    //    override func main() {
    
    private func applyFilter(name: String, parametr: [String: Any]) -> UIImage? {
        
        guard let filter = CIFilter(name: name, parameters: parametr),
            let outputImage = filter.outputImage,
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent) else {return nil}
        return UIImage(cgImage: cgiImage)
    }
    
    //функции по выбору фильтров
    //1 Noir
    public func doNoirFilter(originalImage: UIImage) -> UIImage? {
        guard let ciimage = CIImage(image: originalImage) else {return nil}
            return applyFilter(name: "CIPhotoEffectNoir", parametr: [kCIInputImageKey: ciimage])
    }
    //2 Fade
    public func doFadeFilter(originalImage: UIImage) -> UIImage? {
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        return applyFilter(name: "CIPhotoEffectFade", parametr: [kCIInputImageKey: ciimage])
    }
    //3 Sepia
    public func doSepiaFilter(originalImage: UIImage) -> UIImage? {
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        return applyFilter(name: "CISepiaTone", parametr: [kCIInputImageKey: ciimage])
    }
    //3 Blur
    public func doBlurFilter(originalImage: UIImage) -> UIImage? {
        guard let ciimage = CIImage(image: originalImage) else {return nil}
        return applyFilter(name: "CIBoxBlur", parametr: [kCIInputImageKey: ciimage])
    }
}
