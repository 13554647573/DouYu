//
//  BaseGameModel.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/29.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

class BaseGameModel: NSObject {
    
    // MARK: 定义属性
    /// 组显示的标题
    @objc var tag_name : String = ""
    /// 游戏对应的图标
    @objc var icon_url : String = ""
    
    // MARK: 自定义构造函数
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
