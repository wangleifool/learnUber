//
//  WLHomePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa



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
    
    //全局标识
    var isSelectFromSuggestChoices = false //表示是否从推荐地址中，选择了一个
    
    //路径规划
    var driverRouteSearch: BMKRouteSearch!
    var driverRouteCurrentStep: UInt! = 1
    var driverRouteLastStep: UInt! = 0
    
    
    
    //标识点的移动
    var startPointInLine :CLLocationCoordinate2D! = CLLocationCoordinate2D()//获取每个分段的起点与终点
    var endPointInLine :CLLocationCoordinate2D! = CLLocationCoordinate2D()
    var straightSlopeInLine :Double = 0.0// 每段这个直线的斜率
    
    var driverLatitudeChangeOffset :Double = 0.0//用来判断移动时，经纬度该加还是该减
    var driverLongitudeChangeOffset :Double = 0.0
    
    var test :[String:Int]? = Dictionary()
    
    let disposeBag = DisposeBag()
    
    //自定义的转场动画
    lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // #MARK: - VC 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate

// set navigation title
//        let logoUrl = Bundle.main.path(forResource: "logo_uber_grey_zh_CN@2x", ofType: "png")
//        let imageView = UIImageView(image: UIImage(contentsOfFile: logoUrl!))
//        self.navigationItem.titleView = imageView
        
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = UIColor(red: 65.0 / 255.0, green: 62.0 / 255.0, blue: 78.0 / 255.0, alpha: 1)
        navBar.isTranslucent = false  //不要设置半透明效果
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.title = "UBER"        
        setNavigationItem(title: "ic_menu@3x.png", selector: #selector(self.btShowMenuPressed(sender:)), isRight: false)
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

    
    @IBAction func btTimerClicked(_ sender: Any) {
        let timerVC = WLTimeCounterViewController()
        self.navigationController?.pushViewController(timerVC, animated: true)
    }
    
    

}
