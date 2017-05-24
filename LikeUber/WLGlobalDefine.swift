//
//  WLGlobalDefine.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation
import UIKit


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
