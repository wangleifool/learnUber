//
//  WLPhotoBrower.swift
//  LikeUber
//
//  Created by lei wang on 2018/3/7.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit
import KSPhotoBrowser


class WLPhotoBrower: KSPhotoBrowser {

    var selectedPhotosIdex: [Int]!
    
    lazy var btSelectedDone: UIButton = {
        var frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        frame.x = self.view.bounds.width - frame.width
        let bt = UIButton(frame: frame)
        bt.contentHorizontalAlignment = .center
        bt.setTitle("完成", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.addTarget(self, action: #selector(btDonePressed), for: .touchUpInside)
        
        return bt
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.btSelectedDone)
    }

    @objc func btDonePressed() {
        
    }
    
}
