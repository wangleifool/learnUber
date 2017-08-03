//
//  WLHomePage-Test.swift
//  LikeUber
//
//  Created by lei wang on 2017/6/16.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation


extension WLHomePageViewController {
    
    func addStarView() {
        let view = WLstarView(frame: CGRect(x: 100, y: 400, width: 32, height: 32))
        
        self.view.addSubview(view)
        self.view.bringSubview(toFront: view)
    }
    
}
