//
//  WLCarAnnotationView.swift
//  LikeUber
//
//  Created by lei wang on 2017/8/31.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLCarAnnotationView: BMKAnnotationView {
    var imageView: UIImageView!
    var carDirection: carDirections = .faceNorth{
        willSet(newDirection){  //属性观察器,设置属性之前调用
            
            let valueDiffer = newDirection.rawValue - carDirections.faceNorth.rawValue
//
//            if valueDiffer == 0 {
//                return //意思是 方向没变
//            }
//            
//            //从西到北，只应该顺时针转90度
//            if valueDiffer == -3 {
//                valueDiffer = 1
//            }
            self.rotateCarImageView(rotateValue: valueDiffer)
        }
    }
    
    
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
        self.backgroundColor = UIColor.clear
        
        imageView = UIImageView(image: UIImage(named: "map-black.png"))
        imageView.frame = self.bounds
        
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    func rotateCarImageView(rotateValue: Int) {
//        // 1.创建动画
//        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
//        
//        // 2.设置动画的属性
//        rotationAnim.fromValue = 0
//        rotationAnim.toValue = Double.pi / 2.0 * Double(rotateValue)
//        rotationAnim.repeatCount = 1
//        rotationAnim.duration = 2
//        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
//        rotationAnim.isRemovedOnCompletion = false
//        
//        // 3.将动画添加到layer中
//        imageView.layer.add(rotationAnim, forKey: nil)
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                let angle = (Double.pi / 2.0 * Double(rotateValue))
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            }
        }
        
        
    }
}
