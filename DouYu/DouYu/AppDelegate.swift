//
//  AppDelegate.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/20.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // 修改标签控制器的颜色
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
}

