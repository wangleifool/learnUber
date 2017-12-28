//
//  WLSettingsViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLSettingsViewController: WLBasePageViewController {

    @IBOutlet var userBackView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setNavigationItem(title: "Close.png", selector: #selector(self.doBack), isRight: false)
        
        
        self.mainScrollView.contentSize = CGSize(width: 0, height: userBackView.frame.size.height)
        self.mainScrollView.addSubview(userBackView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
