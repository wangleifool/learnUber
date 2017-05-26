//
//  WLHomePage-Map.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/25.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation


extension WLHomePageViewController {

    func addBaiduMapView() {
        if mapView == nil {
            mapView = BMKMapView(frame: self.view.bounds)
            self.view.addSubview(mapView!)
            
            //其他设置
            mapView?.showMapScaleBar   = true
            mapView?.isTrafficEnabled  = true
            mapView?.zoomLevel = 15
            
            geoCode = BMKGeoCodeSearch() //地理编码查询
            showMyLocation()
        }
        
        
    }
    
    
    //# MARK: - 显示我的定位
    func showMyLocation() {
        localService = BMKLocationService()
        localService?.delegate = self
        localService?.startUserLocationService()
        
        //显示定位图层
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode  = BMKUserTrackingModeHeading
        
        
        self.perform(#selector(self.btMyLocationPressed(_:)), with: nil, afterDelay: 1.0)
    }
    
    //方向发送旋转
//    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
//        print("heading is %@",userLocation.heading);
//    }
    
    //位置发生移动
    func didUpdate(_ userLocation: BMKUserLocation!) {
//        print("didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        mapView?.updateLocationData(userLocation)
    }
    
    @IBAction func btMyLocationPressed(_ sender: Any) {
        if ((localService?.userLocation.location) != nil) {
            mapView?.setCenter((localService?.userLocation.location.coordinate)!, animated: true)
            mapView?.updateLocationData(localService?.userLocation)
        }
        
    }
    
    // #MARK: 图钉反地理编码
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        let point = mapView.convert(btTuDing.center, toCoordinateFrom: self.view)
        
        let option = BMKReverseGeoCodeOption()
        option.reverseGeoPoint = point
        
        geoCode?.reverseGeoCode(option)
        
        textFieldAddress.resignFirstResponder()
    }
    
    //代理反馈，查询到反地理编码的地址
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        textFieldAddress.placeholder = result.address
    }
    
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
    }
}
