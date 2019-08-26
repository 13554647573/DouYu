//
//  PageContentView.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/26.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

// UICollectionView的标识符
private let contentCell = "contentCell"

class PageContentView: UIView {

    // 创建UICollectionView
    private lazy var collectionView: UICollectionView = {[weak self] in
        
        // 设置UICollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = (self?.bounds.size)!
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCell)
        return collectionView
    }()
    
    // 声明控制器数组
    private var childVCArray: [UIViewController]
    // 声明父类控制器
    private weak var parentVC: UIViewController?
    
    init(frame: CGRect, childVCArray: [UIViewController], parentVC: UIViewController?) {
        
        // 存值
        self.childVCArray = childVCArray
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI
extension PageContentView {
    
    private func setupUI () {
        
        // 将所有传入的子控制器装在父控制器中
        for childVC in childVCArray {
            
            self.parentVC?.addChild(childVC)
        }
        
        // 添加 UICollectionView 用于在 cell 中存放控制器 view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}


// MARK:- UICollectionView
extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return childVCArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 创建Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCell, for: indexPath)
        
        // 先移除，在添加，防止重复
        for view in cell.contentView.subviews {
            
            view.removeFromSuperview()
        }
        
        // 赋值
        let childVC = childVCArray[indexPath.row]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
}
