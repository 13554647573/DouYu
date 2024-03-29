
//
//  RecommendViewModel.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/29.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit

class RecommendViewModel  {
    
    lazy var anchorGroups : [AnchorGroupModel] = [AnchorGroupModel]()

    // MARK: 懒加载属性
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    private lazy var bigDataGroup : AnchorGroupModel = AnchorGroupModel()
    private lazy var prettyDataGroup : AnchorGroupModel = AnchorGroupModel()
    
}


// MARK: 发送网络请求
extension RecommendViewModel {
    
    // 请求推荐数据
    func requestData(finishCallback: @escaping () -> ()) {
        
        //0. 定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime() as NSString]
        //0.1 创建 Group
        let dispatchGroup = DispatchGroup()
        
        //1. 请求第一部分推荐数据
        // 进入 DispatchGroup 组
        dispatchGroup.enter()
        // http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1555492932
        NetWorkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentTime() as NSString]) { (result) in
            
            //1.1. 将 result 转成字典类型
            guard let resultDic = result as? [String : NSObject] else { return }
            
            //1.2. 根据 data 该 key，获取数组
            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else { return }
            
            //1.3 遍历数组，获取字典，并将字典转成模型对象
            //1.3.1 设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            //1.3.2 获取主播数据
            for dict in dataArray {
                self.bigDataGroup.anchors.append(AnchorModel.init(dict: dict))
            }
            
            //1.4 离开组
            dispatchGroup.leave()
//            print("请求到1")
            
        }
        
        
        //2. 请求第二部分颜值数据
        //进入组
        dispatchGroup.enter()
        NetWorkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            
            //2.1. 将 result 转成字典类型
            guard let resultDic = result as? [String : NSObject] else { return }
            
            //2.2. 根据 data 该 key，获取数组
            guard let dataArray = resultDic["data"] as? [[String : NSObject]] else { return }
            
            //2.3 遍历数组，获取字典，并将字典转成模型对象
            //2.3.1 设置组的属性
            self.prettyDataGroup.tag_name = "颜值"
            self.prettyDataGroup.icon_name = "home_header_phone"
            
            //2.3.2 获取主播数据
            for dict in dataArray {
                self.prettyDataGroup.anchors.append(AnchorModel.init(dict: dict))
            }
            
            //2.4 离开组
            dispatchGroup.leave()
//            print("请求到2")
            
        }
        
        
        //3. 请求2-12部分游戏数据
        //进入组
        dispatchGroup.enter()
  
        NetWorkTools.requestData(type:.get, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            
            //1. 获取字典数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }

                
            //2.2 遍历 dataArray 所有的字典
            for dict in dataArray {
                let group = AnchorGroupModel(dict:dict)
                self.anchorGroups.append(group)
            }

            // 离开组
            dispatchGroup.leave()
//            print("请求到3")
        }
        
        
        //4. 所有数据都请求到，进行排序
        dispatchGroup.notify(queue: .main) {
            
//            print("所有的数据都请求到")
            self.anchorGroups.insert(self.prettyDataGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallback()
        }
    }
    
    
    // 请求无限轮播的数据
    // http://capi.douyucdn.cn/api/v1/slide/6?version=2.300
    func requestCycleData(finishCallback : @escaping () -> ()) {

        NetWorkTools.requestData(type: .get, URLString: "http://capi.douyucdn.cn/api/v1/slide/6", parameters: ["version":"2.300"]) { (result) in

            //1. 获取整体的字典数据
            guard let resultDict = result as? [String : NSObject] else { return }

            //2. 根据字典的 key 获取 data 数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }

            //3. 字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }

            finishCallback()

        }

    }
}
