//
//  WLStopWatchHand.swift
//  LikeUber
//
//  Created by lei wang on 2017/6/16.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

@IBDesignable
class WLStopWatchHand: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        StopWatchStyleKit.drawWatchHand()
    }
 

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
}
