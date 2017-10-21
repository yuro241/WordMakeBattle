//
//  ResultViewController.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ResultViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timeViewLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let userData = UserDefaults.standard
    var score: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scoreCul()
        setLayout()
    }
    
    func setLayout() {
        timeViewLabel.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.bounds.height / 2)
            make.centerX.equalToSuperview()
        }
        timeViewLabel.text = "タイム: " + String(format:"%.1f", userData.float(forKey: "time"))
        countLabel.snp.makeConstraints{(make) in
            make.top.equalTo(self.view.bounds.height / 4)
            make.centerX.equalToSuperview()
        }
        countLabel.text = String(userData.integer(forKey: "count")) + "文字"
        scoreLabel.snp.makeConstraints{(make) in
            make.top.equalTo((self.view.bounds.height / 4) * 3)
            make.centerX.equalToSuperview()
        }
        scoreLabel.text = "スコア: " + String(format:"%.2f", userData.float(forKey: "score"))
    }
    
    func scoreCul() {
        score = userData.float(forKey: "time") * 0.8 * Float(userData.integer(forKey: "count") * 2)
        userData.set(score, forKey: "score")
    }
}
