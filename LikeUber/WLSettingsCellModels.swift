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
    
    init(iconName:String?, titleName:String, valueName:String?) {
        self.icon = iconName
        self.title = titleName
        self.value = valueName
    }
}
