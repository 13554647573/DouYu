//
//  HomeViewController.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/20.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

// pageView的高度
private let kTitleViewH : CGFloat = 40

// MARK:-主入口
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI
        setUI()
    }
  
    // pageView
    private lazy var pageView: PageTitleView = {[weak self] in
        
        let frame = CGRect(x: 0, y: kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: frame, titles: titles)
        return titleView
    }()
    
    // PageContentView
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        // 获取frame
        let contentY: CGFloat = kNavigationBarH + kTitleViewH
        let contentFrame = CGRect(x: 0, y: contentY, width: kScreenW, height: kScreenH - contentY - kTabBarH)
        
        // 装载VC
        var childArr = [UIViewController]()
        childArr.append(RecommendViewController())
        childArr.append(GameViewController())
        childArr.append(AmuseViewController())
        childArr.append(FunnyViewController())
        
        let contentView = PageContentView(frame: contentFrame, childVCArray: childArr, parentVC: self)
        return contentView
    }()
}


// MARK: 设置UI
extension HomeViewController{
    
    private func setUI() {
        
        // 设置导航栏
        setNavigationUI()
        
        // 添加pageView
        view.addSubview(pageView)
        
        // 添加pageContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = .white
    }
    
    // 设置导航栏
    private func setNavigationUI() {
        
        //1. 设置左侧 item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", viewController: self, selector: #selector(logoAction))
        
        //2. 设置右侧 item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size, viewController: self, selector: #selector(historyAction))
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size, viewController: self, selector: #selector(searchAction))
        let grcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size, viewController: self, selector: #selector(scanAction))
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,grcodeItem]
    }
}


// MARK: 监听事件点击
extension HomeViewController {
    
    @objc fileprivate func logoAction() {
        print("logo")
    }
    
    @objc fileprivate func historyAction() {
        print("历史记录")
    }
    
    @objc fileprivate func searchAction() {
        print("搜索")
    }
    
    @objc fileprivate func scanAction() {
        print("浏览")
    }
}


extension HomeViewController {
    
    
}
