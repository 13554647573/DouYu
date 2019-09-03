//
//  PageContentView.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/26.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

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
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCell)
        return collectionView
    }()
    
    // 声明控制器数组
    private var childVCArray: [UIViewController]
    // 声明父类控制器
    private weak var parentVC: UIViewController?
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    private var startOffsetX : CGFloat = 0.0

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



// MARK: 对外暴露的方法
extension PageContentView {
    
    func setContentIndex(currentIndex: Int) {
        
        //1. 记录需要禁止进行代理方法
        isForbidScrollDelegate = true
        
        //2. 滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
}


// MARK: 遵守 UICollectionViewDelegate 协议
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0. 判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        //1. 定义获取需要的数据
        // progress偏移的比例
        var progress : CGFloat = 0.0
        // 原来的下标
        var sourceIndex : Int = 0
        // 滑动后选中的下标
        var targetIndex : Int = 0
        
        //2. 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        if currentOffsetX > startOffsetX { // 左滑
            
            //2.1 计算 progress
            // floor是取整 举例： 假设currentOffsetX / scrollViewW = 2.5
            // progress = 2.5 - 2
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            //2.2 计算 sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //2.3 计算 targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCArray.count {
                targetIndex = childVCArray.count - 1
            }
            
            //2.4 如果完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else { // 右滑
            
            // 逻辑是反过来的
            //2.1 计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2.2 计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //2.3 计算 sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCArray.count {
                sourceIndex = childVCArray.count - 1
            }
            
        }
        
        //3. 将 progress/sourceIndex/targetIndex 传递给 titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
}




