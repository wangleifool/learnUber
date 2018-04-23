//
//  WLGlobalDefine.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation
import UIKit

//顺时针
enum carDirections: Int {
    case faceNorth = 0
    case faceEast  = 1
    case faceSouth = 2
    case faceWest  = 3
}

enum driverState {
    case driveToAnywhere
    case driveToGuestStartPlace
    case driveToGuestTargetPlace
}

//常量
let iOS8:Float = 8.0
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth  = UIScreen.main.bounds.size.width
let NavigationBarHeight = 64

//调试打印方法
func WlLog(_ message:String, file:String = #file, function:String = #function, line:Int = #line) {
    print("WLLog:\(message), File:\(file), Function:\(function), Line:\(line)");
}

func isIPad() -> Bool {
    if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
        return true;
    } else {
        return false;
    }
}

func isIPhone() -> Bool {
    if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
        return true;
    } else {
        return false;
    }
}

func isRetina() -> Bool {
    if UIScreen.main.scale >= 2.0 {
        return true;
    } else {
        return false;
    }
}

func isSystemiOS8()->Bool
{
    let version:NSString = UIDevice.current.systemVersion as NSString
    
    if (version.floatValue - iOS8 < -0.001) {
        return true;
    }
    
    return false;
}


func documentsPath() -> String {
    return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
}

func shakeAnimation(with view: UIView) {
    // 获取到当前的View
    let viewLayer:CALayer = view.layer
    
    // 获取当前View的位置
    let position = viewLayer.position
    
    // 移动的两个终点位置
    let x = CGPoint.init(x: position.x + 10, y: position.y)
    
    let y = CGPoint.init(x: position.x - 10, y: position.y)
    
    // 设置动画
    let animation:CABasicAnimation = CABasicAnimation(keyPath: "position")
    
    // 设置运动形式
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
    
    // 设置开始位置
    animation.fromValue = NSValue.init(cgPoint: x)
    
    // 设置结束位置
    animation.toValue = NSValue.init(cgPoint: y)
    
    // 设置自动反转
    animation.autoreverses = true
    
    // 设置时间
    animation.duration = 0.06
    
    // 设置次数
    animation.repeatCount = 3
    
    
    // 添加上动画
    viewLayer.add(animation, forKey: nil)
    
}
