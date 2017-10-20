//
//  ResultViewController.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timeViewLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    let userData = UserDefaults.standard
    
    var score: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreCul()
        userData.synchronize()
        timeViewLabel.text = String(format:"%.1f", userData.float(forKey: "time"))
        countLabel.text = String(userData.integer(forKey: "count"))
        scoreLabel.text = String(format:"%.2f", userData.float(forKey: "score"))
    }
    
    func scoreCul() {
        score = userData.float(forKey: "time") * Float(userData.integer(forKey: "count") * 2)
        userData.set(score, forKey: "score")
    }
    
}
