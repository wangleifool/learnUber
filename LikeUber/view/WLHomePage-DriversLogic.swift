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
        let point = BMKPointAnnotation()
        
        //实际开发，司机的经纬度是由服务器反馈的
        point.coordinate = CLLocationCoordinate2D(latitude: (self.startPoiPlace?.pt.latitude)!-0.002, longitude: (self.startPoiPlace?.pt.longitude)!+0.001)
        
        //初始化一个driver的model对象
        driver = WLUberDriver()
        driver?.driverName = "老司机"
        driver?.driverPhone = "18683717777"
        driver?.driverCarAnnotation = point
        
        point.title = driver?.driverName
        
        self.mapView?.addAnnotation(point)
        
        
    }
    
    //指定自定义 annotation view 的代理
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        let car = WLCarAnnotationView(annotation: annotation, reuseIdentifier: "PID")
        car?.isDraggable = false
        
        driver?.driverCarAnnotationView = car //记录下annotationView
        
        return car
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
    
    func timerEvent() {
        
//        if let oldCarAnnotation = self.driver?.driverCarAnnotation {
//            
//            //计算新的值
//            let newCarAnnotation = self.simulateCaculateCarLocation(oldCarAnnotation: oldCarAnnotation)
//            
//            DispatchQueue.main.async {
//                //移除旧的annotation
//                self.mapView?.removeAnnotation(oldCarAnnotation)
//                
//                //添加新的annotation
//                self.mapView?.addAnnotation(newCarAnnotation)
//                self.driver?.driverCarAnnotation = newCarAnnotation //更新car annotation
//            }
//        }
        
        //不需要从地图上移除annotation，直接更新他的坐标即可
        if let oldCarAnnotation = self.driver?.driverCarAnnotation {
            //计算新的值
            let newCarAnnotation = self.simulateCaculateCarLocation(oldCarAnnotation: oldCarAnnotation)
            DispatchQueue.main.async {
                self.driver?.driverCarAnnotation.coordinate = CLLocationCoordinate2D(latitude: newCarAnnotation.coordinate.latitude, longitude: newCarAnnotation.coordinate.longitude)
            }
        }
        
    }
    
    //模拟车的位置
    func simulateCaculateCarLocation(oldCarAnnotation: BMKPointAnnotation) -> BMKPointAnnotation {
        
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
            }
            break
        case .faceNorth?:
            newLatitude += postionOffsetUnit
            if newLatitude >= maxLatitude {
                driverCarDirection = .faceEast
            }
            break
        case .faceEast?:
            newLongitude += postionOffsetUnit
            if newLongitude >= maxLongitude {
                driverCarDirection = .faceSouth
            }
            break
        case .faceWest?:
            newLongitude -= postionOffsetUnit
            if newLongitude <= minLongitude {
                driverCarDirection = .faceNorth
            }
            break
        default:
            driverCarDirection = .faceSouth
            break
        }
        
        driver?.driverCarAnnotationView?.carDirection = driverCarDirection
        
        //实际开发，司机的经纬度是由服务器反馈的
        carAnnotation.coordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
        
        //                print("car latitude: \(String(describing: carAnnotation?.coordinate.latitude)) , car longitude: \(String(describing: carAnnotation?.coordinate.longitude))")
        

        return carAnnotation
    }
}
