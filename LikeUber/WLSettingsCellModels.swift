//
//  WLSettingsModels.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/5.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation


class WLSettingsCellModels: NSObject {
    var icon:String?
    var title:String
    var value:String?
    var isExpand: Bool = false
    var canExpand: Bool = false // 最顶端的cell，不支持展开
    
    init(iconName: String? = nil,
         titleName: String,
         valueName: String? = nil,
         canExpand: Bool = false) {
        self.icon = iconName
        self.title = titleName
        self.value = valueName
        self.canExpand = canExpand
    }
}
