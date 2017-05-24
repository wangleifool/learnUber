//
//  WLBaseViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setNavigationItem(title:String,selector:Selector,isRight:Bool) {
        var barButtonItem:UIBarButtonItem
        
        if title.hasSuffix("png") {
            barButtonItem = UIBarButtonItem(image: UIImage(named:title), style: .plain, target: self, action: selector)
        } else {
            barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        }
        
        if isRight {
            self.navigationItem.rightBarButtonItem = barButtonItem
        } else {
            self.navigationItem.leftBarButtonItem  = barButtonItem
        }
    }

}
