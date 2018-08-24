//
//  Const.swift
//  LikeUber
//
//  Created by wanglei on 2018/8/24.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation

struct Const {
    static let screenBounds = UIScreen.main.bounds
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let navigationBarHeight: CGFloat = 44.0
    static let statusBarHeight: CGFloat = (UIDevice.current.screenType == .iPhoneX) ? (44.0) : (20.0)
    static let navBarAndStatusBarHeight: CGFloat = navigationBarHeight + statusBarHeight
    static let tabbarHeight: CGFloat = (UIDevice.current.screenType == .iPhoneX) ? 83.0 : 44.0
    static let bottomDangerAreaHeight: CGFloat = 34.0
}
