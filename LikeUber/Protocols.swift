//
//  Protocols.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/2.
//  Copyright © 2018年 lei wang. All rights reserved.
//

// 这里约定一些辅助的类型

import Foundation
import UIKit
import RxSwift
import RxCocoa

// 定义一个 Textfiled输入框可能会遇到的状态
enum Result {
    case Empty
    case Ok(message: String)
    case Failed(message: String)
}

// 扩展 Result ，添加属性
extension Result {
    var isValid:Bool {   //计算型属性
        switch self {
        case .Ok:
            return true
        default:
            return false
        }
    }
}

extension Result {
    var textColor:UIColor {
        switch self {
        case .Empty:
            return UIColor.black
        case .Failed:
            return UIColor.red
        case .Ok:
            return UIColor.blue
        }
    }
}

extension Result {
    var description: String {
        switch self {
        case .Empty:
            return ""
        case let .Failed(message):
            return message
        case let .Ok(message):
            return message
        }
    }
}


// 自定义监听类型
extension Reactive where Base : UILabel {
    var validateResult : UIBindingObserver<Base,Result> {
        return UIBindingObserver(UIElement: base, binding: { (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        })
    }
    
}

extension Reactive where Base: UITextField {
    var inputEnabled: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base) { textFiled, result in
            textFiled.isEnabled = result.isValid
        }
    }
    
//    var validateTextColor : UIBindingObserver<Base,Result> {
//        return UIBindingObserver(UIElement: base, binding: { (textField, result) in
//            textField.textColor = result.isValid ? UIColor.black : UIColor.red
//        })
//    }
}
