//
//  WLHomePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLHomePageViewController: WLBasePageViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {

    var appDelegate:AppDelegate?
    var mapView:BMKMapView?
    var localService:BMKLocationService?
    var curLocation:BMKUserLocation?
    
    var geoCode:BMKGeoCodeSearch? //地理编码 查询
    
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var btTuDing: UIButton!
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var topSearchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate

//        self.title = "Home"
        let logoUrl = Bundle.main.path(forResource: "logo_uber_grey_zh_CN@2x", ofType: "png")
        let imageView = UIImageView(image: UIImage(contentsOfFile: logoUrl!))
        self.navigationItem.titleView = imageView
        setNavigationItem(title: "account_icon_up.png", selector: #selector(self.settingPressed(sender:)), isRight: false)
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加百度地图视图
        addBaiduMapView()
        
        //view 上的子视图
        self.view.bringSubview(toFront: btTuDing)
        self.view.bringSubview(toFront: btMyLocation)
        self.view.bringSubview(toFront: topSearchView)
        
        mapView?.delegate = self
        geoCode?.delegate = self
        localService?.startUserLocationService() //开启定位服务
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.delegate = nil
        geoCode?.delegate = nil
        localService?.stopUserLocationService() //停止定位服务
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
