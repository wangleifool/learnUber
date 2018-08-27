//
//  WLTimeCounterViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/6/16.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class WLTimeCounterViewController: WLBasePageViewController {

    @IBOutlet weak var stopWatchHand: WLStopWatchHand!
    var isBreakWatch: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isBreakWatch = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rotateStopWatchHand()
    }

    func rotateStopWatchHand() {
        UIView.animate(withDuration: 15.0, delay: 0, options: .curveLinear, animations: {
            self.stopWatchHand.transform =
                self.stopWatchHand.transform.rotated(by: CGFloat(Double.pi/2))
        }, completion: { finished in
            if !self.isBreakWatch {  //拒绝死循环消耗资源
                self.rotateStopWatchHand()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isBreakWatch = true
    }

}
