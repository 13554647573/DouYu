//
//  CollectionHeaderView.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/28.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    // MARK: 控件属性
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    
    
    // MARK: 定义模型属性
    var group : AnchorGroupModel? {
        
        didSet {
            
            guard let group = group else {
                return
            }
            titleLabel.text = group.tag_name
            iconImageView.image = UIImage(named: group.icon_name )
            
        }
        
    }
}


// MARK: 从 xib 中快速创建类方法
extension CollectionHeaderView {
    
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
    
}
