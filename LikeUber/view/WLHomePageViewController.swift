//
//  WLHomePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLHomePageViewController: WLBasePageViewController,BMKMapViewDelegate {

    var appDelegate:AppDelegate?
    var mapView:BMKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate

//        self.title = "Home"
        let logoUrl = Bundle.main.path(forResource: "logo_uber_grey_zh_CN@2x", ofType: "png")
        let imageView = UIImageView(image: UIImage(contentsOfFile: logoUrl!))
        self.navigationItem.titleView = imageView
        setNavigationItem(title: "account_icon_up@2x.png", selector: #selector(self.settingPressed(sender:)), isRight: false)
        
        //添加百度地图视图
        addBaiduMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBaiduMapView() {
        mapView = BMKMapView(frame: self.view.bounds)
        self.view.addSubview(mapView!)
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
