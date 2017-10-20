
//
//  APIRequest.swift
//  techHack
//
//  Created by Yuichiro Tsuji on 2017/10/19.
//  Copyright © 2017年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class APIRequest: UIViewController {
    let url = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict"
//    let userData = UserDefaults.standard
    var isExist: Bool = false
    
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
