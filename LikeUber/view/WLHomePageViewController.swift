//
//  WLHomePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLHomePageViewController: WLBasePageViewController {

    var appDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate

//        self.title = "Home"
        let logoUrl = Bundle.main.path(forResource: "logo_uber_grey_zh_CN@2x", ofType: "png")
        let imageView = UIImageView(image: UIImage(contentsOfFile: logoUrl!))
        self.navigationItem.titleView = imageView
        setNavigationItem(title: "account_icon_up@2x.png", selector: #selector(self.settingPressed(sender:)), isRight: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func settingPressed(sender:Any) {
        //得到父级视图控制器drawerController
        if let drawerController = appDelegate?.window?.rootViewController as? KYDrawerController {
            if drawerController.drawerState == .closed {
                drawerController.setDrawerState(.opened, animated: true)
            } else {
                drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }

    

}
