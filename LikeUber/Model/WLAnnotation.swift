//
//  WLAnnotation.swift
//  LikeUber
//
//  Created by lei wang on 2017/9/11.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLAnnotation: BMKPointAnnotation {
    var type: Int!///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点 6：司机
    var degree: Int!
    
    override init() {
        super.init()
    }
    
    init(type: Int, degree: Int) {
        self.type = type
        self.degree = degree
    }
}
