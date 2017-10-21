//
//  AlphabetBase.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import Foundation

struct Alphabet {
    static let consonantArray: Array<String> = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"]
    static let vowelsArray: Array<String> = ["A","E","I","O","U"]
    static let consonantCount: Int = consonantArray.count
    static let vowelCount: Int = vowelsArray.count
    
    static let consonantButtonNum: Int = 10
    static let vowelButtonNum: Int = 5
}
