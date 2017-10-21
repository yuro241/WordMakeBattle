//
//  ViewController.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SWXMLHash

class MainViewController: UIViewController {
    @IBOutlet weak var answerView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    
    var margin_width: CGFloat = 0.0
    var margin_vowel_width: CGFloat = 10
    var margin_height: CGFloat = 0.0
    
    var answer: String = ""
    var timeCount: Float = 20.0
    var timer: Timer!
    let url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict"
    var isExist: Bool = false
    let userData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        margin_width = self.view.bounds.width / 12
        margin_vowel_width = self.view.bounds.width / 6
        margin_height = self.view.bounds.height / 4
        
        answerView.layer.borderWidth = 1.0
        answerView.layer.borderColor = UIColor.gray.cgColor
        answerView.layer.cornerRadius = 8.0
        answerButton.addTarget(self, action: #selector(self.sendAnswer), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(self.deleteAnswer), for: .touchUpInside)
        deleteAllButton.addTarget(self, action: #selector(self.deleteAllAnswer), for: .touchUpInside)
        
        consonantButtonSet(length:Alphabet.consonantCount, letters:Alphabet.consonantArray, count: Alphabet.consonantButtonNum)
        vowelButtonSet(length: Alphabet.vowelCount, letters: Alphabet.vowelsArray, count: Alphabet.vowelButtonNum)
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
            
            //レイアウトちゃんとしたい
            button.snp.makeConstraints{(make) in
                make.top.equalTo(self.view.snp.top).offset(margin_height)
                make.left.equalTo(self.view.snp.left).offset(CGFloat(num) * margin_width + 30)
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
            
            //レイアウトちゃんとしたい
            button.snp.makeConstraints{(make) in
                margin_height = self.view.bounds.height / 2.5
                make.top.equalTo(self.view.snp.top).offset(margin_height)
                make.left.equalTo(self.view.snp.left).offset(CGFloat(num) * margin_vowel_width + 50)
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
    
    func getList(_ text: String) -> Bool {
        let path = url + "&Word=" + text + "&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=XHTML&PageSize=20&PageIndex=0"
        var result: String?
        var keepAlive = true
        let comp: String? = "0"
        
        let runLoop = RunLoop.current
        Alamofire.request(path).response{ response in
            let xml = SWXMLHash.parse(response.data!)
            result = xml["SearchDicItemResult"]["ItemCount"].element?.text
            keepAlive = false
        }
        while keepAlive &&
            runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {}
        
        if result != comp {
            isExist = true
        } else {
            isExist = false
        }
        return isExist
    }
}

