//
//  WLHomePage-DriversLogic.swift
//  LikeUber
//
//  Created by lei wang on 2017/8/31.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation



extension WLHomePageViewController {
    
    func showNearbyDrivers() {
//        let point = BMKPointAnnotation()
        let point = WLAnnotation()                
        point.type = 6
        
        //实际开发，司机的经纬度是由服务器反馈的
        point.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!-0.002, longitude: (self.startPoiPlace?.pt.longitude)!+0.001)
        
        //初始化一个driver的model对象
        driver = WLUberDriver()
        driver?.driverName = "老司机"
        driver?.driverPhone = "18683717777"
        driver?.driverCarAnnotation = point
        
        point.title = driver?.driverName
        
        self.mapView?.addAnnotation(point)
        
        self.resumeDriverUpdateLocationTimer()
        
//        let driverAnnotation1 = BMKPointAnnotation()
//        
//        //实际开发，司机的经纬度是由服务器反馈的
//        driverAnnotation1.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!+0.002, longitude: (self.startPoiPlace?.pt.longitude)!+0.001)
//        
//        let driverAnnotation2 = BMKPointAnnotation()
//        
//        //实际开发，司机的经纬度是由服务器反馈的
//        driverAnnotation2.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!-0.004, longitude: (self.startPoiPlace?.pt.longitude)!+0.0012)
//        
//        let driverAnnotation3 = BMKPointAnnotation()
//        
//        //实际开发，司机的经纬度是由服务器反馈的
//        driverAnnotation3.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!+0.0012, longitude: (self.startPoiPlace?.pt.longitude)!-0.001)
//        let driverAnnotation4 = BMKPointAnnotation()
//        
//        //实际开发，司机的经纬度是由服务器反馈的
//        driverAnnotation4.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!+0.0012, longitude: (self.startPoiPlace?.pt.longitude)!-0.0012)
//        
//        let dirverArray:[BMKPointAnnotation] = [driverAnnotation1,driverAnnotation2,driverAnnotation3,driverAnnotation4]
//        self.mapView?.addAnnotations(dirverArray)
    }
    
    func addDriverToMap(coordinate: CLLocationCoordinate2D) {
        let point = WLAnnotation()
        point.type = 6
        
        //实际开发，司机的经纬度是由服务器反馈的
        point.coordinate = coordinate
        
        //初始化一个driver的model对象
        driver?.driverCarAnnotation = point
        
        self.mapView?.addAnnotation(point)
    }
    
    // #MARK: 指定自定义 annotation view 的代理
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
//        if annotation is WLAnnotation {
//            print("annotation is BMKPointAnnotation")
//        }      
        
        
        if let wlAnnotation = annotation as! WLAnnotation? {
            return getViewForRouteAnnotation(wlAnnotation)
        }
        
        return nil
    }
    
    func getViewForRouteAnnotation(_ wlAnnotation: WLAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        var imageName: String?
        switch wlAnnotation.type {
        case 0:
            imageName = "nav_start"
        case 1:
            imageName = "nav_end"
        case 2:
            imageName = "nav_bus"
        case 3:
            imageName = "nav_rail"
        case 4:
            imageName = "direction"
        case 5:
            imageName = "nav_waypoint"
        case 6:
            //车辆annotation需要单独提供view
            var car = mapView.dequeueReusableAnnotationView(withIdentifier: "PID")
            if car == nil {
                car = WLCarAnnotationView(annotation: wlAnnotation, reuseIdentifier: "PID")
                car?.isDraggable = false
                driver?.driverCarAnnotationView = car as! WLCarAnnotationView //记录下annotationView
            }
            
            
            return car
        default:
            return nil
        }
        
        let identifier = "\(String(describing: imageName))_annotation"
        view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: wlAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPoint(x: 0, y: -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        
        view?.annotation = wlAnnotation
        
        let bundlePath = (Bundle.main.resourcePath)! + "/mapapi.bundle/"
        let bundle = Bundle(path: bundlePath)
        var tmpBundle : String?
        tmpBundle = (bundle?.resourcePath)! + "/images/icon_\(imageName!).png"
        if let imagePath = tmpBundle {
            var image = UIImage(contentsOfFile: imagePath)
            if wlAnnotation.type == 4 {
                image = imageRotated(image, degrees: wlAnnotation.degree)
            }
            if image != nil {
                view?.image = image
            }
        }
        
        return view
    }
    
    //旋转图片
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * Double.pi / 180.0));
        bitmap?.rotate(by: CGFloat(Double.pi));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }

    
    func showSuggestDriver() {
        
    }
    
    func caculateRoutesFromDriverToMe(startPlace: BMKPoiInfo, targetPlace: BMKPoiInfo) {
        
    }
    
    
    
    // #MARK: - 定时器模拟司机车辆的位置更新
    func addDriverUpdateLocationTimer() {
        
        let serialQueue = DispatchQueue(label: "driverUpdateTimer")
        serialQueue.async {
            self.driverTimer = Timer(timeInterval: 0.05, target: self, selector: #selector(self.timerEvent), userInfo: nil, repeats: true)
            //        driverTimer?.fire()
            RunLoop.current.add(self.driverTimer!, forMode: .commonModes)
            RunLoop.current.run()
        }
    }
    
    func cancelDriverUpdateLocationTimer() {
        driverTimer?.invalidate()
        driverTimer = nil
    }
    
    func pauseDriverUpdateLocationTimer() {
        driverTimer?.fireDate = Date.distantFuture
    }
    
    func resumeDriverUpdateLocationTimer() {
        driverTimer?.fireDate = Date()
    }
    
    @objc func timerEvent() {
        
        //不需要从地图上移除annotation，直接更新他的坐标即可
        if let oldCarAnnotation = self.driver?.driverCarAnnotation {
            //计算新的值
            let newCarAnnotation = self.simulateCaculateCarLocation(oldCarAnnotation: oldCarAnnotation)
            DispatchQueue.main.async {
                self.driver?.driverCarAnnotation.coordinate = CLLocationCoordinate2D(latitude: newCarAnnotation.coordinate.latitude, longitude: newCarAnnotation.coordinate.longitude)
            }
        }
        
    }
    
    func simulateDriveToAnywhereCarLocation(oldCarAnnotation: BMKPointAnnotation) -> BMKPointAnnotation {
        let theCarLastCoordinate = oldCarAnnotation.coordinate
        
        let carAnnotation = BMKPointAnnotation()
        
        //获取手机地图尺寸对应的 坐标边界
        // 调试结果证明，同一水平线， latitude 相同 Top‘s latitude > tottom's latitude
        // 同一垂直线， longitude 相同 ， Right's longitude > Left's longitude
        let leftTopCoordinate = mapView?.convert(CGPoint(x: 0,y: 0), toCoordinateFrom: self.view)
        //        let leftBottomCoordinate = mapView?.convert(CGPoint(x: 0,y: self.view.bounds.height), toCoordinateFrom: self.view)
        //        let rightTopCoordinate = mapView?.convert(CGPoint(x: self.view.bounds.width,y: 0), toCoordinateFrom: self.view)
        let rightBottomCoordinate = mapView?.convert(CGPoint(x: self.view.bounds.width,y: self.view.bounds.height), toCoordinateFrom: self.view)
        
        //        print("leftTopCoordinate: (\(String(describing: leftTopCoordinate!.latitude)) , car longitude: \(String(describing: leftTopCoordinate!.longitude)))")
        //        print("leftBottomCoordinate: (\(String(describing: leftBottomCoordinate!.latitude)) , car longitude: \(String(describing: leftBottomCoordinate!.longitude)))")
        //        print("rightTopCoordinate: (\(String(describing: rightTopCoordinate!.latitude)) , car longitude: \(String(describing: rightTopCoordinate!.longitude)))")
        //        print("rightBottomCoordinate: (\(String(describing: rightBottomCoordinate!.latitude)) , car longitude: \(String(describing: rightBottomCoordinate!.longitude)))")
        let maxLatitude = leftTopCoordinate!.latitude - 0.0028
        let minLatitude = rightBottomCoordinate!.latitude + 0.001
        let maxLongitude = rightBottomCoordinate!.longitude - 0.001
        let minLongitude = leftTopCoordinate!.longitude + 0.001
        
        var newLatitude:CLLocationDegrees = theCarLastCoordinate.latitude
        var newLongitude:CLLocationDegrees = theCarLastCoordinate.longitude
        
        //移动位置，到达边界，改变方向
        switch driverCarDirection {
        case .faceSouth?:
            newLatitude -= postionOffsetUnit
            if newLatitude <= minLatitude {
                driverCarDirection = .faceWest
                driver?.driverCarAnnotationView?.carDirection = driverCarDirection
            }
            break
        case .faceNorth?:
            newLatitude += postionOffsetUnit
            if newLatitude >= maxLatitude {
                driverCarDirection = .faceEast
                driver?.driverCarAnnotationView?.carDirection = driverCarDirection
            }
            break
        case .faceEast?:
            newLongitude += postionOffsetUnit
            if newLongitude >= maxLongitude {
                driverCarDirection = .faceSouth
                driver?.driverCarAnnotationView?.carDirection = driverCarDirection
            }
            break
        case .faceWest?:
            newLongitude -= postionOffsetUnit
            if newLongitude <= minLongitude {
                driverCarDirection = .faceNorth
                driver?.driverCarAnnotationView?.carDirection = driverCarDirection
            }
            break
        default:
            driverCarDirection = .faceSouth
            driver?.driverCarAnnotationView?.carDirection = driverCarDirection
            break
        }
        
        
        
        //实际开发，司机的经纬度是由服务器反馈的
        carAnnotation.coordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
        
        //                print("car latitude: \(String(describing: carAnnotation?.coordinate.latitude)) , car longitude: \(String(describing: carAnnotation?.coordinate.longitude))")
        
        
        return carAnnotation
    }
    
    //实时计算车的位置
    func caculateCarLocation(oldCarAnnotation: BMKPointAnnotation) -> BMKPointAnnotation{
        if let driverRoute  = self.driver?.driverRoute {
            if driverRoute.pointCount < 1 {
                return BMKPointAnnotation()
            }
            
            if driverRoute.pointCount == driverRouteCurrentStep {
                driverArriveTargetPlace() //到达地点，
            }
            
            let carAnnotation = BMKPointAnnotation()
            
            //开始新的一段 直线的移动,计算他的相关参数
            if driverRouteLastStep != driverRouteCurrentStep {
                
                //将路径分段移动车辆
                let points = self.driver?.driverRoute?.points
                //获取每个分段的起点与终点
                let startPoint :BMKMapPoint = points![Int(driverRouteLastStep)]  //获取当前的走到第几个记录点
                startPointInLine = BMKCoordinateForMapPoint(startPoint)
                
                let endPoint :BMKMapPoint = points![Int(driverRouteCurrentStep)]  //获取当前的走到第几个记录点
                endPointInLine = BMKCoordinateForMapPoint(endPoint)
                
                //用来判断移动时，经纬度该加还是该减
                driverLatitudeChangeOffset  = endPointInLine.latitude - startPointInLine.latitude
                driverLongitudeChangeOffset = endPointInLine.longitude - startPointInLine.longitude
                
                //计算每个分段的直线斜率
                straightSlopeInLine = driverLatitudeChangeOffset / driverLongitudeChangeOffset
                
                driverRouteLastStep = driverRouteCurrentStep //初始化工作完成
                
                carAnnotation.coordinate = startPointInLine //设置车的位置为起点
                
            } else {  //还在一段直线的移动中
                let curPointCoordinate = oldCarAnnotation.coordinate
                
                var newPointCoordinate = CLLocationCoordinate2D()
                
                //判断维度该加还是该减
                if driverLatitudeChangeOffset > 0 {
                    newPointCoordinate.latitude = curPointCoordinate.latitude + postionOffsetUnit
                    //如果维度超过了终点，我们认为这一段到达终点了
                    if newPointCoordinate.latitude >= endPointInLine.latitude {
                        driverRouteCurrentStep = driverRouteCurrentStep + 1 //走到下一段直线
                    }
                } else {
                    newPointCoordinate.latitude = curPointCoordinate.latitude - postionOffsetUnit
                    //如果维度超过了终点，我们认为这一段到达终点了
                    if newPointCoordinate.latitude <= endPointInLine.latitude {
                        driverRouteCurrentStep = driverRouteCurrentStep + 1 //走到下一段直线
                    }
                }
                
                //带入直线方程，求经度 (lati1-lati0)/(long1-long0) = K  ;
                //long1 = (lati1-lati0)/K + long0
                newPointCoordinate.longitude = (newPointCoordinate.latitude-startPointInLine.latitude)/straightSlopeInLine + startPointInLine.longitude
                
                
                
                //设置carAnnotation的坐标
                carAnnotation.coordinate = newPointCoordinate
            }
            
//            print("car latitude: \(String(describing: carAnnotation.coordinate.latitude)) , car longitude: \(String(describing: carAnnotation.coordinate.longitude))")
            
        
            
            return carAnnotation
        }
        
        return BMKPointAnnotation()
    }
    
    //模拟车的位置
    func simulateCaculateCarLocation(oldCarAnnotation: BMKPointAnnotation) -> BMKPointAnnotation {
        
        switch self.driver?.state {
        case .driveToAnywhere?:
            return simulateDriveToAnywhereCarLocation(oldCarAnnotation: oldCarAnnotation)
        case .driveToGuestStartPlace?,
             .driveToGuestTargetPlace?:
            return caculateCarLocation(oldCarAnnotation:oldCarAnnotation)
        default: break
            
        }
        
        return BMKPointAnnotation()
    }
    
    // #MARK: - 规划路线
    func startSchemRoute() {
//        schemRouteFromDriverToMe()
        
        self.carRouteSearch(start: self.startPoiPlace!, target: self.targetPoiPlace!)
//        self.btTuding.isHidden = true
    }
    
    //附近司机到我的路线
    func schemRouteFromDriverToMe() {
        
        if let driverPt = self.driver?.driverCarAnnotation {
            pauseDriverUpdateLocationTimer()
            let driverPoiInfo = BMKPoiInfo()
            driverPoiInfo.pt  = driverPt.coordinate
            self.carRouteSearch(start: driverPoiInfo, target: self.startPoiPlace!)
        } else {
            print("附近没有合适的司机")
        }
        
    }
   
    
    func startDriveToTargetPlace(routeLine: BMKPolyline) {
        
        //开始让司机开往客户的起点
        self.driver?.state = .driveToGuestTargetPlace
        self.driver?.driverRoute = routeLine
        let startCoordinate = BMKCoordinateForMapPoint(routeLine.points[Int(0)])
        self.addDriverToMap(coordinate: startCoordinate)
        
        
        resumeDriverUpdateLocationTimer() //恢复定时器
    }
    
    func driverArriveTargetPlace() {
        pauseDriverUpdateLocationTimer() //暂停计时器
        
        self.driver?.state = .driveToAnywhere //后期改成到达的属性
        
        //显示到达的交互
        
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.showAlertView(title: "消息", message: "恭喜你，达到目的地，欢迎下次乘坐")
        }
        
    }
    
}
