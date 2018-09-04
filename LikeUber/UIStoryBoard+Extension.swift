//
//  UIStoryBoard+Extension.swift
//  LikeUber
//
//  Created by wanglei on 2018/9/4.
//  Copyright © 2018 lei wang. All rights reserved.
//

import UIKit

// 遵循该协议的都支持一个identifier的属性，并且它的值 是 自己这个对象的描述文本 String(describing: self)。如：
//struct Point {
//    let x: Int, y: Int
//}
//
//let p = Point(x: 21, y: 30)
//print(String(describing: p))
//// Prints "Point(x: 21, y: 30)"
protocol StoryboardIdentifierable: class {
    static var identifier: String { get }
}

extension StoryboardIdentifierable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {

    typealias VStoryboardable = UIViewController & StoryboardIdentifierable

    // match the Storyboard name
    public enum Storyboard: String {
        case menu
        var name: String {
            return rawValue.capitalized // 让首字母大写
        }
    }

    // 提供使用 Storyboard枚举进行初始化的方法
    public convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.name, bundle: bundle)
    }

    // 实例方法， 一个UIStoryboard实例可以指定对应的viewC， 必须是 继承UIViewController和遵循StoryboardIdentifierable的
    func instantiateViewController<T: VStoryboardable>(viewType: T.Type) -> T {
        guard let vc = self.instantiateViewController(withIdentifier: viewType.identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(viewType.identifier)")
        }
        return vc
    }


    /// // 类方法，返回VC实例
    ///
    /// - Parameters:
    ///   - storyboard: 指定storyboard。（枚举值）
    ///   - viewType: 指定一个UIStoryboard实例可以指定对应的viewC， 必须是 继承UIViewController和遵循StoryboardIdentifierable
    /// - Returns: 返回你指定的VC实例
    class func instantiateViewController<T: VStoryboardable>(storyboard: Storyboard, viewType: T.Type) -> T {
        return UIStoryboard(storyboard).instantiateViewController(viewType: viewType)
    }
}
