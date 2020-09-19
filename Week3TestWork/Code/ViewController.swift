//
//  ViewController.swift
//  Week3TestWork
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var bruteForcedTimeLabel: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var generatePasswordButton: UIButton!
    
    private let passwordGenerate = PasswordGenerator()
    private let characterArray = Consts.characterArray
    private let maxTextLength = Consts.maxTextFieldTextLength
    private var password = ""
    
    
    
    
//    let secondpassWordGeneration = PassWordGenerationSecond(password: "", characterArray: Consts.characterArray)
    let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        disableStartButton()
        
        //Hide keyboard on screen tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tap)
        inputTextField.delegate = self
    }
    
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func generatePasswordButtonPressed(_ sender: UIButton) {
        clearText()
        inputTextField.text = passwordGenerate.randomString(length: 4)
        enableStartButton()
    }
    
    @IBAction func startBruteFoceButtonPressed(_ sender: Any) {
        guard let text = inputTextField.text else {
            return
        }
        password = text
        clearText()
        disableStartButton()
        statusLabel.text = "Status: in process"
        indicator.isHidden = false
        indicator.startAnimating()
        generatePasswordButton.isEnabled = false
        generatePasswordButton.alpha = 0.5
        start()
    }
    
    private func start() {
        let startIndexOperation = StartIndexOperation(password: self.password, characterArray: Consts.characterArray)
        let endIndexOperation = EndIndexOperation(password: self.password, characterArray: Consts.characterArray)
        var result: String?
        
        let findPassWithStartIndex = BlockOperation {
            let startTime = Date()
            result = startIndexOperation.bruteForce(startString: "0000")
            print("1\(Thread.current)")
            DispatchQueue.main.async {
                self.stop(password: result ?? "Error", startTime: startTime)
            }
        }

        let findPassWithEndIndex = BlockOperation {
            let startTime = Date()
            result = endIndexOperation.bruteForce(endString: "ZZZZ")
            print("2\(Thread.current)")
            DispatchQueue.main.async {
                self.stop(password: result ?? "Error", startTime: startTime)
            }
        }
        
        DispatchQueue.global().async {
            findPassWithStartIndex.start()
            if findPassWithStartIndex.isFinished == true {
                findPassWithStartIndex.cancel()
                findPassWithEndIndex.cancel()
                
            }
        }
        DispatchQueue.global().async {
            findPassWithEndIndex.start()
            if findPassWithEndIndex.isFinished == true {
                findPassWithEndIndex.cancel()
                findPassWithStartIndex.cancel()
            }
        }
    }

    //Обновляем UI
    private func stop(password: String, startTime: Date) {
        
        indicator.stopAnimating()
        enableStartButton()
        indicator.isHidden = true
        generatePasswordButton.isEnabled = true
        generatePasswordButton.alpha = 1
        passwordLabel.text = "Password is: \(password)"
        statusLabel.text = "Status: Complete"
        bruteForcedTimeLabel.text = "\(String(format: "Time: %.2f", Date().timeIntervalSince(startTime))) seconds"
        
    }
    
    private func clearText() {
        statusLabel.text = "Status:"
        bruteForcedTimeLabel.text = "Time:"
        passwordLabel.text = "Password is:"
    }
    
    private func disableStartButton() {
        startButton.isEnabled = false
        startButton.alpha = 0.5
    }
    
    private func enableStartButton() {
        startButton.isEnabled = true
        startButton.alpha = 1
    }
}

// Добавляем делегат для управления вводом текста в UITextField
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let charCount = inputTextField.text?.count else {
            return
        }
        if charCount != maxTextLength {
            Alert.showBasic(title: "Incorrect password", message: "Password must be 4 characters long", vc: self)
        }
        if charCount > 3 {
            enableStartButton()
        } else {
            disableStartButton()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearText()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        
        let acceptableCharacters = Consts.joinedString
        let characterSet = CharacterSet(charactersIn: acceptableCharacters).inverted
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
        let filtered = newString.rangeOfCharacter(from: characterSet) == nil
        return newString.count <= maxTextLength && filtered
    }
    
}
