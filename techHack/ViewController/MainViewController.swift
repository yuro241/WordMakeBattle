//
//  ViewController.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: APIRequest {
    @IBOutlet weak var answerView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    //この辺はbaseでまとめたい
    let lettersArray = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"]
    let vowelsArray = ["A","E","I","O","U"]
    let consonantButtonNum: Int = 10
    let vowelButtonNum: Int = 5
    
    var answer: String = ""
    var timeCount: Float = 20.0
    var timer: Timer!
    let userData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerView.layer.borderWidth = 1.0
        answerView.layer.borderColor = UIColor.gray.cgColor
        answerView.layer.cornerRadius = 8.0
        answerButton.addTarget(self, action: #selector(self.sendAnswer), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteAnswer), for: .touchUpInside)
        deleteAllButton.addTarget(self, action: #selector(self.deleteAllAnswer), for: .touchUpInside)
        
        consonantButtonSet(length:lettersArray.count, letters:lettersArray, count: consonantButtonNum)
        vowelButtonSet(length: vowelsArray.count, letters: vowelsArray, count: vowelButtonNum)
        setButtonDisable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startTimer()
    }
    
    func consonantButtonSet(length: Int, letters: Array<String>, count: Int) {
        for num in 0 ..< count {
            let button = UIButton()
            let rand = Int(arc4random()) % length
            let randomAlphabet:String = letters[rand]
            
            button.setTitle(randomAlphabet, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 8.0
            button.addTarget(self, action: #selector(self.buttonEvent(sender:)), for: .touchUpInside)
            button.sizeToFit()
            self.view.addSubview(button)
            
            button.snp.makeConstraints{(make) in
                make.top.equalTo(self.view.snp.top).offset(175)
                make.left.equalTo(self.view.snp.left).offset(num * 30 + 35)
            }
        }
    }
    
    func vowelButtonSet(length: Int, letters: Array<String>, count: Int) {
        for num in 0 ..< count {
            let button = UIButton()
            let Alphabet:String = letters[num]
            
            button.setTitle(Alphabet, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 8.0
            button.addTarget(self, action: #selector(self.vowelButtonEvent(sender:)), for: .touchUpInside)
            button.sizeToFit()
            self.view.addSubview(button)
            
            button.snp.makeConstraints{(make) in
                make.top.equalTo(self.view.snp.top).offset(275)
                make.left.equalTo(self.view.snp.left).offset(num * 60 + 55)
            }
        }
    }
    
    func buttonEvent(sender: UIButton) {
        print(sender.titleLabel!.text!)
        answer = answer + sender.titleLabel!.text!
        answerView.text = answer
        sender.isEnabled = false
        sender.layer.borderColor = UIColor.red.cgColor
        sender.setTitleColor(UIColor.red, for: .normal)
        setButtonEnable()
    }
    
    func vowelButtonEvent(sender: UIButton) {
        print(sender.titleLabel!.text!)
        answer = answer + sender.titleLabel!.text!
        answerView.text = answer
        setButtonEnable()
    }

    func sendAnswer() {
        //apiで判定
        timer.invalidate()
        userData.set(timeCount, forKey: "time")
        if getList(answer) {
            userData.set(answer.characters.count, forKey: "count")
            performSegue(withIdentifier: "clear", sender: nil)
        } else {
            performSegue(withIdentifier: "faild", sender: nil)
        }
    }
    
    func deleteAnswer() {
        let nsAnswer = (answer as NSString).substring(to: answer.count - 1)
        answer = nsAnswer as String
        answerView.text = answer
        if answerView.text == "" {
            setButtonDisable()
        }
    }
    
    func deleteAllAnswer() {
        answer = ""
        answerView.text = answer
        setButtonDisable()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.upDate(timer:)), userInfo: nil, repeats: true)
    }
    
    func upDate(timer: Timer) {
        if timeCount < 0.1 {
            timer.invalidate()
            userData.set(timeCount, forKey: "time")
            performSegue(withIdentifier: "faild", sender: (Any).self)
        }
        timeCount -= 0.1
        let str = String(format:"%.1f", timeCount)
        timeLabel.text = str
        
    }
    
    func setButtonEnable() {
        answerButton.isEnabled = true
        deleteButton.isEnabled = true
        deleteAllButton.isEnabled = true
    }
    
    func setButtonDisable() {
        answerButton.isEnabled = false
        deleteButton.isEnabled = false
        deleteAllButton.isEnabled = false
    }
}

