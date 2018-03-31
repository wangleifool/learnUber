//
//  UIColor-extension.swift
//  LikeUber
//
//  Created by lei wang on 2018/3/19.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation

extension UIColor {
    
    static func setGradualChangingColor(view: UIView, fromColor fromHexColorStr: String,toColor toHexColorStr: String) -> CAGradientLayer {
        //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        //  创建渐变色数组，需要转换为CGColor颜色
        gradientLayer.colors =  [UIColor.init(hex: fromHexColorStr).cgColor,UIColor.init(hex: toHexColorStr).cgColor]
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        //  设置颜色变化点，取值范围 0.0 ~ 1.0
        gradientLayer.locations = [0,1];
        
        return gradientLayer;
    }
    
    
    
}
