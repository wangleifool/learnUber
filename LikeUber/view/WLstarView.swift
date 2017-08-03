//
//  WLstarView.swift
//  LikeUber
//
//  Created by lei wang on 2017/6/16.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLstarView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Color Declarations
        let color = UIColor(red: 0.786, green: 0.707, blue: 0.168, alpha: 1.000) //orange
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.29)
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowBlurRadius = 5
        
        
        
        //// Star Drawing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 16, y: 0))
        starPath.addLine(to: CGPoint(x: 21.64, y: 8.23))
        starPath.addLine(to: CGPoint(x: 31.22, y: 11.06))
        starPath.addLine(to: CGPoint(x: 25.13, y: 18.97))
        starPath.addLine(to: CGPoint(x: 25.4, y: 28.94))
        starPath.addLine(to: CGPoint(x: 16, y: 25.6))
        starPath.addLine(to: CGPoint(x: 6.6, y: 28.94))
        starPath.addLine(to: CGPoint(x: 6.87, y: 18.97))
        starPath.addLine(to: CGPoint(x: 0.78, y: 11.06))
        starPath.addLine(to: CGPoint(x: 10.36, y: 8.23))
        starPath.close()
        context.saveGState()
    
        
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        color.setFill()
        starPath.fill()
        context.restoreGState()        
    }
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }

}
