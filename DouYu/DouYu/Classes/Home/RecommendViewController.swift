//
//  RecommendViewController.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/26.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

// MARK: 常量
let kNormalItemW : CGFloat = (kScreenW - kItemMargin * 3) / 2
let kNormalItemH : CGFloat = kNormalItemW * 3 / 4
let kPrettyItemH : CGFloat = kNormalItemW * 4 / 3
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
private let kItemMargin : CGFloat = 10.0
private let kHeaderViewH : CGFloat = 50.0
private let kGameViewH : CGFloat = 90.0


private let kNormalCellID = "kNormalCellID"
private let kHeaderViewID = "kHeaderViewID"
let kPrettyCellID = "kPrettyCellID"

class RecommendViewController: UIViewController {

    // 热门，颜值等数据model
    private lazy var recommendViewModel : RecommendViewModel = RecommendViewModel()
    private lazy var gameViewModel : GameViewModel = GameViewModel()

    // 无限轮播图
    private lazy var cycleView : RecommendCycleView = {
     
        let view = RecommendCycleView.recommendCycleView()
        view.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return view
    }()
    
    private lazy var gameView : RecommendGameView = {
        
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        
        return gameView
    }()

    // 热门 颜值等
    private lazy var collectionView : UICollectionView = { [unowned self] in
        
        //1. 创建布局
        let layout = UICollectionViewFlowLayout()
        // 设置cell的宽高
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        // 设置item的行间距（上下）
        layout.minimumLineSpacing = 0
        // 设置item与item的间距（左右）
        layout.minimumInteritemSpacing = kItemMargin
        // 设置头部视图的w宽高
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        // 设置内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //2. 创建 UICollectionView
        let kCollectionViewH : CGFloat = kScreenH - kNavigationBarH - 40 - kTabBarH
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kCollectionViewH), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        // 因为设置collectionView的frame为self.view.bounds，所以需要根据View的宽高自适应
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
         // 自定义情况下注册注册UICollectionViewCell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        // 自定义情况下注册注册UICollectionViewCell
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        // 自定义情况下注册头部视图Section
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        // collectionView内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI
        setupUI()
    }
}



// MARK:- 设置UI
extension RecommendViewController {
    
    private func setupUI () {
        
        // 添加collectionView
        view.addSubview(collectionView)
        
        // 推荐请求
        loadData()
        
        // 添加cycleView
        collectionView.addSubview(cycleView)
        
        //3. 将 gameView 添加到 collectionView 上
        collectionView.addSubview(gameView)
    }
}


// MARK:-网络请求
extension RecommendViewController {
    
    private func loadData () {
        
        // 1. 展示推荐数据
        recommendViewModel.requestData {
            
            self.collectionView.reloadData()
            
            //1.2 将数据传递给 GameView
            var groups = self.recommendViewModel.anchorGroups
            //1.2.1 先移除前两组数据
            groups.removeFirst()
            groups.removeFirst()
            
            //1.2.2 添加"更多"组
            let moreGroup = AnchorGroupModel()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            self.gameView.groups = groups
            
        }
        
        // 2. 请求轮播数据
        recommendViewModel.requestCycleData {
            
            self.cycleView.cycleModels = self.recommendViewModel.cycleModels
        }
        
    }
}

extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 设置section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
         return recommendViewModel.anchorGroups.count
    }
    
    // 设置row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recommendViewModel.anchorGroups[section].anchors.count
    }
    
    // 创建cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CollectionBaseCell!
        
        if indexPath.section == 1 {
            
            //1. 取出 cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
   
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        
        cell.anchor = recommendViewModel.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        return cell
    }
    
    // 设置头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //1. 取出 headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        //2. 给 headerView 设置数据
        headerView.group = recommendViewModel.anchorGroups[indexPath.section]
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }else{
            return CGSize(width: kNormalItemW, height: kNormalItemH)
        }
    }
}
