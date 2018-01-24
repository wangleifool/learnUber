//
//  WLZanAnimationButton.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/16.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

class WLZanAnimationButton: UIButton {

    lazy var emitterLayer:CAEmitterLayer = {
        let emitter = CAEmitterLayer()
        emitter.emitterSize = CGSize(width: 30.0, height: 30.0)
        emitter.renderMode = kCAEmitterLayerAdditive
        emitter.masksToBounds = false
        
        return emitter
    }()
    
    var zanLabel:UILabel = UILabel()
    var emojiImages = [String]()
    var emitterCells = [CAEmitterCell]()   // 专门用来装 粒子 对象的
    var countNum = 0
//    lazy var textUpdateTimer:Timer = {
//        let timer = Timer(timeInterval: 1.5, target: self, selector: #selector(self.setText), userInfo: nil, repeats: true)
//        return timer
//    }()
    private var timer: DispatchSourceTimer?
    var pageStepTime: DispatchTimeInterval = .milliseconds(150)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    func setup() {
        
        zanLabel.frame = CGRect(x: -50, y: -100, width: 200, height: 40)
        zanLabel.isHidden = true
        self.addSubview(zanLabel)
        
        self.layer.addSublayer(self.emitterLayer)
        
        // 配置按钮 相关
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onePress)))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPress)))
        
        self.setImage(UIImage(named:"feed_like_press"), for: .selected)
        self.setImage(UIImage(named:"feed_like"), for: .normal)
        
        
        
        
    }

    
    @objc func onePress(sender: UIGestureRecognizer) {
        if let button = sender.view as? UIButton {
            if button.isSelected {
                button.isSelected = false
            } else {
                button.isSelected = true
                
                startAnimate()
                
                self.perform(#selector(self.stopEmitter), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    @objc func longPress(sender: UIGestureRecognizer) {
        if let button = sender.view as? UIButton {
            button.isSelected = true
            
            if sender.state == .began {
                startAnimate()
            } else if sender.state == .ended {
                stopEmitter()
            }
        }
    }
    
    
    
    
    // deadline 结束时间
    // interval 时间间隔
    // leeway  时间精度
    func startTheTimer() {
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + pageStepTime, repeating: pageStepTime)
        timer?.setEventHandler {
            self.setText()
        }
        
        timer?.resume()
    }
    
    func deinitTimer() {
        if let time = self.timer {
            time.cancel()
            timer = nil
        }
    }
    
    
    @objc func setText() {
        print("setText ing ....")
        countNum = (countNum >= 999) ? 999 : countNum+1
        
        
        let baiWei = countNum / 100 // 百位
        let shiWei = countNum % 100 / 10  // 十位
        let geWei  = countNum % 10  // 个位
        
        var attributeString = NSMutableAttributedString()
        
        if baiWei != 0 {
            let baiTA = NSTextAttachment()
            if let img = UIImage(named: "multi_digg_num_".appendingFormat("%d", baiWei)) {
                baiTA.image = img
                baiTA.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                let aString = NSAttributedString(attachment: baiTA)
                attributeString.append(aString)
            }
        }
        
        if shiWei != 0 {
            let shiTA = NSTextAttachment()
            if let img = UIImage(named: "multi_digg_num_".appendingFormat("%d", shiWei)) {
                shiTA.image = img
                shiTA.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                let aString = NSAttributedString(attachment: shiTA)
                attributeString.append(aString)
            }
        }
        
        let geTA = NSTextAttachment()
        if let img = UIImage(named: "multi_digg_num_".appendingFormat("%d", geWei)) {
            geTA.image = img
            geTA.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            let aString = NSAttributedString(attachment: geTA)
            attributeString.append(aString)
        }
        
        if countNum < 5 {
            if let img = UIImage(named: "multi_digg_word_level_1") {
                let textAttachment = NSTextAttachment()
                textAttachment.image = img
                textAttachment.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                let aString = NSAttributedString(attachment: textAttachment)
                attributeString.append(aString)
            }
        } else if countNum < 10 {
            if let img = UIImage(named: "multi_digg_word_level_2") {
                let textAttachment = NSTextAttachment()
                textAttachment.image = img
                textAttachment.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                let aString = NSAttributedString(attachment: textAttachment)
                attributeString.append(aString)
            }
        } else {
            if let img = UIImage(named: "multi_digg_word_level_3") {
                let textAttachment = NSTextAttachment()
                textAttachment.image = img
                textAttachment.bounds = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
                let aString = NSAttributedString(attachment: textAttachment)
                attributeString.append(aString)
            }
        }
        
        
        zanLabel.attributedText = attributeString
        self.zanLabel.textAlignment = .center;
    }
    
    
    
    /**
     *  开始喷射
     */
    func startAnimate() {
        
        emojiImages.removeAll()
        emitterCells.removeAll()
        
        // 随机10张emoji
        for i in 1 ... 10 {
            let randomIndex = Int(arc4random() % 77) + i
            let str = "emoji_".appendingFormat("%d", randomIndex)
            emojiImages.append(str)
        }
        
        // 制作粒子对象
        for name in emojiImages {
            let emitterCell = createEmitterCell(name: name)
            emitterCells.append(emitterCell)
        }
        
        self.emitterLayer.emitterCells = emitterCells
        
        //emitterLayer开始时间
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.birthRate = 1
        for emitter in emitterCells {
            emitter.birthRate = 7
        }
        
        zanLabel.isHidden = false
        startTheTimer()
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyAnimation.values = [0.8,1.0]
        keyAnimation.duration = 0.4
        zanLabel.layer.add(keyAnimation, forKey: "transform.scale")
        
    }
    
    // 停止喷射
    @objc func stopEmitter() {
        emitterLayer.birthRate = 0
        
        self.deinitTimer()
        
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyAnimation.values = [1.0,0.1]
        keyAnimation.duration = 0.4
        zanLabel.layer.add(keyAnimation, forKey: "transform.scale")
        
        zanLabel.isHidden = true
        countNum = 0
        
    }
    
    func createEmitterCell(name: String) -> CAEmitterCell {
        let smoke = CAEmitterCell()
        
        smoke.birthRate = 0 //每秒出现多少个粒子
        smoke.lifetime = 2 // 粒子的存活时间
        smoke.lifetimeRange = 2
        smoke.scale = 0.35
        
        smoke.alphaRange = 1
        smoke.alphaSpeed = -1.0//消失范围
        smoke.yAcceleration = 450//可以有下落的效果
        
        smoke.contents = UIImage(named: name)?.cgImage
        smoke.name = name //设置这个 用来展示喷射动画 和隐藏
        
        smoke.velocity = 450//速度
        smoke.velocityRange = 30// 平均速度
        smoke.emissionLongitude = CGFloat(3 * Double.pi / 2)
        smoke.emissionRange = CGFloat(Double.pi/2)//粒子的发散范围
        smoke.spin = CGFloat(Double.pi * 2) // 粒子的平均旋转速度
        smoke.spinRange = CGFloat(Double.pi * 2)// 粒子的旋转速度调整范围
        
        return smoke;
    }
    
}
