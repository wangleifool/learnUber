//
//  WLHomePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import enum Result.NoError


//图钉针尖位置
let TuDingTipScale:CGFloat = (1.52/5.36)

class WLHomePageViewController: WLBasePageViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKCloudSearchDelegate,BMKSuggestionSearchDelegate {

    var appDelegate:AppDelegate?
    var mapView:BMKMapView!
    var localService:BMKLocationService?
    var curLocation:BMKUserLocation?
    
    var geoCode:BMKGeoCodeSearch? //地理编码 查询
    var poiSearch:BMKPoiSearch?   //热点搜索
    var cloudSearch:BMKCloudSearch? //LBS云检索
    var suggestionSearch:BMKSuggestionSearch? //推荐查询
    
    
    @IBOutlet weak var textFieldStartAddress: UITextField!
    @IBOutlet weak var textFieldTargetAddress: UITextField!
    var isSearchStartAddress:Bool = true
    
//    @IBOutlet weak var btTuDing: UIButton!
    
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var topSearchView: UIView!
    
    
    lazy var btTuding: UIButton = {
        return self.createTudingButton()
    }()
    
    //查询的时候，实时显示推荐的位置信息
    lazy var suggestionPlaceTableView : UITableView = UITableView()
    var suggestionPlaceArray = [BMKPoiInfo]()
    var isReverseGeoFromShwoSuggestionPlace:Bool = false
    
    //位置信息
    var startPoiPlace: BMKPoiInfo?
    var targetPoiPlace: BMKPoiInfo?
    
    //模拟司机的位置更新
    var driverTimer:Timer?
    var driver:WLUberDriver?    
    var driverCarDirection:carDirections! = .faceNorth //默认朝上走
    let postionOffsetUnit:CLLocationDegrees = 0.00001
    
    //路径规划
    var driverRouteSearch: BMKRouteSearch!
    var driverRouteCurrentStep: UInt! = 0
    
    
    //全局标识
    var isSelectFromSuggestChoices = false //表示是否从推荐地址中，选择了一个
    
    
    // #MARK: - VC 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate


        let logoUrl = Bundle.main.path(forResource: "logo_uber_grey_zh_CN@2x", ofType: "png")
        let imageView = UIImageView(image: UIImage(contentsOfFile: logoUrl!))
        self.navigationItem.titleView = imageView
        setNavigationItem(title: "icon_touxiang.png", selector: #selector(self.settingPressed(sender:)), isRight: false)
        setNavigationItem(title: "Timer", selector: #selector(self.btTimerClicked(_:)), isRight: true)
                
        //监控地址查询输入框中
        self.listenAddressTextFiledInput()
        
        
        //添加定时器
        self.addDriverUpdateLocationTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加百度地图视图
        addBaiduMapView()

        //view 上的子视图
        self.view.addSubview(self.btTuding)
        self.view.bringSubview(toFront: self.btTuding)
        self.view.bringSubview(toFront: btMyLocation)
        self.view.bringSubview(toFront: topSearchView)
        
        addAllMapServiceDelegate()
        
        //添加查询结果tableView
        setupSuggestionPlaceTableView()
        
        
        localService?.startUserLocationService() //开启定位服务
        
        //add some test view
//        self.addStarView()
    }
    
       
    deinit {
        print("HomePage View controller dealloced")
        
        removeAllMapServiceDelegate()
        localService?.stopUserLocationService() //停止定位服务
        self.cancelDriverUpdateLocationTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //目的是把图钉的针尖放到父视图的center位置
    func createTudingButton() -> UIButton{
        let tudingImage = UIImage(named: "TuDing")
        assert(tudingImage != nil,"图钉图片加载失败")
        
        //设置frame为父视图的中心
        var frame = CGRect(x: 0, y: 0, width: tudingImage!.size.width, height: tudingImage!.size.height)
        frame.origin.x = (ScreenWidth-frame.width)/2
        frame.origin.y = (ScreenHeight-frame.height)/2
        
        
        //移动针尖儿到父视图中心
        let xOffset = frame.width*TuDingTipScale //先得到针尖的相对x值
        let yOffset = frame.height/2
        frame.origin.x += ((frame.width/2)-xOffset) //想中间移动合适的距离
        frame.origin.y -= yOffset
        
        let button = UIButton(frame: frame)
        button.setImage(tudingImage, for: .normal)
        
        return button
    }
    
    
    // #MARK: action
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

    
    @IBAction func btTimerClicked(_ sender: Any) {
        let timerVC = WLTimeCounterViewController()
        self.navigationController?.pushViewController(timerVC, animated: true)
    }
    
    

}
