//
//  WLScrollView.swift
//  LikeUber
//
//  Created by wanglei on 2018/11/5.
//  Copyright © 2018 lei wang. All rights reserved.
//

import UIKit

class WLScrollView: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        super.touchesShouldCancel(in: view)
        return true
    }

}
