//
//  WLProgressHUDSwift.swift
//  LikeUber
//
//  Created by lei wang on 2018/4/4.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

class WLProgressHUDSwift: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    
    convenience init(view: UIView) {
        self.init(frame: view.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    
    private func initial() {
        
    }
}
