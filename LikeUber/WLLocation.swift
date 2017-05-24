//
//  WLLocation.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/22.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation
import CoreLocation

class WLLocation: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager? //位置信息管理者
    var curLocationString:String?
    
    func startLocation() {
        //判断服务是否开启
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            
            locationManager?.delegate = self;
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest //精度，越高越耗电
            locationManager?.distanceFilter  = 100 //扫描范围
            
            locationManager?.startUpdatingLocation()
            locationManager?.requestAlwaysAuthorization()
        } else {
        
        }
    }
    
    
    
    //反编码获得地理信息
    func searchAddress(location:CLLocation) {
        let corder = CLGeocoder() //地理反编码 核心类
        corder.reverseGeocodeLocation(location) { (marks:[CLPlacemark]?, error:Error?) in
            if marks != nil {
                for mark in marks! {
                    WlLog("My location :"+mark.name!)
                    self.curLocationString = mark.country!+mark.administrativeArea!+mark.locality!+mark.subLocality!+mark.name!
                }
            }
        }
    }
    
    //更新位置信息 delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        searchAddress(location: locations[0])
        
        //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
        locationManager?.stopUpdatingLocation()
    }
}
