//
//  WLBasePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import RxGesture

class WLBasePageViewController: WLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.rx.swipeGesture(.down,
                             numberOfTouchesRequired: 1,
                             configuration: nil)
            .takeUntil(self.rx.deallocated)
            .when(.recognized)
            .subscribe(onNext: { [weak self] (_) in
                self?.doBack()
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func doBack()
    {
        if (self.navigationController?.viewControllers.count) ?? 0  > 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
