//
//  MainViewController.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/20.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        addChildVC("Home")
        addChildVC("Live")
        addChildVC("Follow")
        addChildVC("Profile")
    }

    
    private func addChildVC (_ name : String) {
        
        // 通过 storyboard 来获取控制器
        // 因为是可选性，所以需要加！
        let childVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        
        // 将自控制器添加
        addChild(childVC)
    }
}
