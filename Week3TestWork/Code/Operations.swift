//
//  Operations.swift
//  Week3TestWork
//
//  Created by Калинин Артем Валериевич on 13.09.2020.
//  Copyright © 2020 E-legion. All rights reserved.
//

import UIKit

class StartIndexOperation: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    var correctPassword = ""
    var password: String
    var startIndexArray = [Int]()
    var startString: String
    let characterArray = Consts.characterArray
    
    init(password: String, startString: String) {
        self.password = password
        self.startString = startString
    }
    
    override func main() {
        let inputPassword = password
        var startIndexArray = [Int]()
        let maxIndexArray = characterArray.count
        
        // Создает массивы индексов из входных строк
        for char in startString {
            for (index, value) in self.characterArray.enumerated() where value == "\(char)" {
                startIndexArray.append(index)
            }
        }
        
        var currentIndexArray = startIndexArray
        
        // Цикл подбора пароля
        
        while !isCancelled {
            
            // Формируем строку проверки пароля из элементов массива символов
            let currentPass = self.characterArray[currentIndexArray[0]] + self.characterArray[currentIndexArray[1]] + self.characterArray[currentIndexArray[2]] + self.characterArray[currentIndexArray[3]]
            
            // Выходим из цикла если пароль найден, или, если дошли до конца массива индексов
            if inputPassword == currentPass {
                correctPassword = currentPass
                
                return
            } else {
                // Если пароль не найден, то происходит увеличение индекса. Для этого в цикле, начиная с последнего элемента осуществляется проверка текущего значения. Если оно меньше максимального значения (61), то индекс просто увеличивается на 1. При этом мы меняем направление работы индекса обратно тому как это работает в сабклассе EndIndexOperation
                //Например было [5, 0, 0, 0] а станет [6, 0, 0, 0]. Если же мы уже проверили последний индекс, например [61, 0, 0, 0], то нужно сбросить его в 0, а "старший" индекс увеличить на 1. При этом далее в цикле проверяется переполение "старшего" индекса тем же алгоритмом.
                //Таким образом [61, 0, 0, 0] станет [0, 1, 0, 0]. И поиск продолжится дальше:  [1, 1, 0, 0],  [2, 1, 0, 0],  [3, 1, 0, 0] и т.д.
                for index in (0 ..< currentIndexArray.count) {
                    guard currentIndexArray[index] < maxIndexArray - 1 else {
                        currentIndexArray[index] = 0
                        continue
                    }
                    currentIndexArray[index] += 1
                    break
                }
            }
        }
    }
}


class EndIndexOperation: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    var correctPassword = ""
    var password: String
    var startIndexArray = [Int]()
    var endString: String
    let characterArray = Consts.characterArray
    
    init(password: String, endString: String) {
        self.password = password
        self.endString = endString
    }
    
    override func main() {
        let inputPassword = password
        var endIndexArray = [Int]()
        let maxIndexArray = characterArray.count
        
        // Создает массивы индексов из входных строк
        for char in endString {
            for (index, value) in self.characterArray.enumerated() where value == "\(char)" {
                endIndexArray.append(index)
            }
        }
        
        var currentIndexArray = endIndexArray
        
        // Цикл подбора пароля
        while !isCancelled {
            
            // Формируем строку проверки пароля из элементов массива символов
            let currentPass = self.characterArray[currentIndexArray[0]] + self.characterArray[currentIndexArray[1]] + self.characterArray[currentIndexArray[2]] + self.characterArray[currentIndexArray[3]]
            
            // Выходим из цикла если пароль найден, или, если дошли до конца массива индексов
            if inputPassword == currentPass {
                correctPassword = currentPass
                
                return
            } else {
                // Если пароль не найден, то происходит увеличение индекса. Для этого в цикле, начиная с последнего элемента осуществляется проверка текущего значения. Если оно меньше максимального значения (61), то индекс просто увеличивается на 1.
                //Например было [0, 0, 0, 5] а станет [0, 0, 0, 6]. Если же мы уже проверили последний индекс, например [0, 0, 0, 61], то нужно сбросить его в 0, а "старший" индекс увеличить на 1. При этом далее в цикле проверяется переполение "старшего" индекса тем же алгоритмом.
                //Таким образом [0, 0, 0, 61] станет [0, 0, 1, 0]. И поиск продолжится дальше:  [0, 0, 1, 1],  [0, 0, 1, 2],  [0, 0, 1, 3] и т.д.
                for index in (0 ..< currentIndexArray.count).reversed() {
                    guard currentIndexArray[index] < maxIndexArray - 1 else {
                        currentIndexArray[index] = 0
                        continue
                    }
                    currentIndexArray[index] += 1
                    break
                }
            }
        }
    }
}

