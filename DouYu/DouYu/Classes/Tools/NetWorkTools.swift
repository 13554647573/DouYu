//
//  NetWorkTools.swift
//  DouYu
//
//  Created by 李   胜 on 2019/8/29.
//  Copyright © 2019 Wuhan Xueyetong Big Data  Institute Co. Ltd. All rights reserved.
//

import UIKit
import Alamofire

class NetWorkTools: NSObject {

    // 加class 代表封装的类方法
    // type是自己定义的枚举
    // parameters是传入的字典，默认是nil
    class func requestData(type: HTTPMethod, URLString: String, parameters: [String : Any]? = nil, finishCallback: @escaping (_ result: AnyObject) -> ()) {
        
        // 发送请求
        Alamofire.request(URLString, method: type, parameters: parameters).responseJSON { (respone) in
            
            // 错误数据处理
            guard let result = respone.result.value else {
                
                print(respone.result.error as Any)
                return
            }
            
            // 将结果返回
            finishCallback(result as AnyObject)
        }
    }

}
