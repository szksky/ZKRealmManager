//
//  ZKRealmManager.swift
//  ZKRealmManager
//
//  Created by shizhankun on 2018/6/12.
//  Copyright © 2018年 szk. All rights reserved.
//

import UIKit

class Person: BaseModel {

    @objc dynamic var id = 0
    @objc dynamic var name:String = ""
    @objc dynamic var desc:String = "test"
    @objc dynamic var dog:Dog? 
    
    
    /// 主键
    ///
    /// - Returns: 增删改查只要依赖对象
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
