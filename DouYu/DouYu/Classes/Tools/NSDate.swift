//
//  NSDate.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/29.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import Foundation

// 返回当前时间戳
extension NSDate {
    
    class func getCurrentTime() -> String {
        
        let nowDate = NSDate()
        
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
}
