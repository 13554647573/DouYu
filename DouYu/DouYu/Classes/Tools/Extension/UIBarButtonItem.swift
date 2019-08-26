//
//  UIBarButtonItem.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/20.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /* 方法一：类方法
     class func createItem(imageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem {
     
     let btn = UIButton()
     
     btn.setImage(UIImage(named: imageName), for: .normal)
     btn.setImage(UIImage(named: highImageName), for: .highlighted)
     btn.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
     
     let barItem = UIBarButtonItem(customView: btn)
     
     return barItem
     }*/
    
    
    // 方法二：构造函数
    // 便利构造函数: 1> 以 convenience 开头   2> 在构造函数中必须明确调用一个设计的构造函数(self)
    convenience init (imageName:String, highImageName:String = "", size: CGSize = CGSize.zero, viewController: UIViewController, selector: Selector) {
        
        //1. 创建 UIButton
        let btn = UIButton()
        btn.addTarget(viewController, action: selector, for: .touchUpInside)
        
        //2. 设置 btn 图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        //3. 设置 btn 尺寸
        if size == CGSize.zero {
            
            btn.sizeToFit()
        }else{
            
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        //4. 创建 UIBarButtonItem
        self.init(customView: btn)
    }
}
