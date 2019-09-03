//
//  PageTitleView.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/26.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2.0
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// MARK: 定义协议
protocol PageTitleViewDelegate : class {
    
    func pageTitleView(titleView : PageTitleView, SelectIndex : Int)
}

class PageTitleView: UIView {

    // 懒加载scrollView
    private lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.frame = bounds
        return scrollView
    }()
    
    // 添加scrollLine
    private lazy var scrollLine : UIView = {
        
        let scrollLine = UIView()
        scrollLine.backgroundColor = .orange
        return scrollLine
    }()
    
    // 默认的选中下标
    private var currentIndex : Int = 0
    // labels 数组
    private lazy var titleLabels : [UILabel] = [UILabel]()
    // 定义协议
    weak var delegate : PageTitleViewDelegate?
    
    // 创建一个字符串数组
    private var titles : [String]
    
    // 创建指定初始化器
    init(frame: CGRect,titles:[String]) {
        
        // 拿到传进来的数组
        self.titles = titles
        
        // 调用父类的初始化器（小细节，必须把其他的存储属性都初始化完毕了，才能调用父类的super.init，不然就会报错）
        super.init(frame: frame)
        
        // 设置UI（小细节，因为初始化是分段的，第一段是初始化，第二段才是其他的设置，所以必须等初始化结束，才能有其他的操作，否则就会报错）
        setupUI()
    }
    
    // 语法糖
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:-设置UI
extension PageTitleView {
    
    private func setupUI () {
        
        // 添加scrollView
        addSubview(scrollView)
        
        // 添加Lbl
        setupTitleLbl()
        
        // 添加底线
        setupLineView()
    }
    
    // 设置里面滚动的Lbl
    private func setupTitleLbl () {
        
        // 计算frame
        let labelW : CGFloat = frame.width/CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0.0
        
        // 通过元祖遍历拿到下标
        for (index,title) in titles.enumerated() {
            
            // 创建label
            let lable = UILabel()
            
            // 设置属性
            lable.text = title
            lable.tag = index
            lable.font = UIFont.systemFont(ofSize: 16.0)
            lable.textColor = UIColor.darkGray
            lable.textAlignment = .center
            
            // 设置frame
            let labelX : CGFloat = labelW * CGFloat(index)
            lable.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 添加到scrollView
            scrollView.addSubview(lable)
            
            // 添加lable到数组中
            titleLabels.append(lable)
            
            // 添加点击手势
            lable.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapG:)))
            lable.addGestureRecognizer(tap)
            
            
        }
    }
    
    // 创建底线
    private func setupLineView () {
        
        // 底线
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        let lineH : CGFloat = 0.5
        lineView.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(lineView)
        
        // 如果没有值就return
        guard let firstLabel = titleLabels.first else {
            return
        }
        // 有值就设置颜色
        firstLabel.textColor = .orange
        
        // 添加scrollLine
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}


// MARK:- 监听 label 点击
extension PageTitleView {
    
    // 切换label的逻辑
    @objc private func titleLabelClick (tapG:UITapGestureRecognizer) {
        
        // 1.如果点击的不是label就直接返回
        guard let currentLabel = tapG.view as? UILabel else { return }
        
        // 2.如果是重复点击同一个 title，那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        // 3.获取之前的 Label
        let oldLabel = titleLabels[currentIndex]
        
        // 4.切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 5.保存最新 Label 的下标值
        currentIndex = currentLabel.tag
        
        // 6.计算滚动条的X值
        let currentLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = currentLineX
        }
        
        delegate?.pageTitleView(titleView: self, SelectIndex: currentIndex)
    }
}



// MARK: 对外暴露的方法
extension PageTitleView {
    
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        //1. 取出 sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2. 处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3. 颜色渐变(复杂)
        //3.1 取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2 变化 sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        //3.3 变化 targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4. 记录最新的 index
        currentIndex = targetIndex
        
    }
    
}
