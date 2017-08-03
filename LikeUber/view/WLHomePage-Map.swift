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
        
        let point = mapView?.convert(btTuDing.center, toCoordinateFrom: self.view)
        
        let option = BMKReverseGeoCodeOption()
        option.reverseGeoPoint = point!
        
        geoCode?.reverseGeoCode(option)
        
        textFieldAddress.resignFirstResponder()
    }
    
    //代理反馈，查询到反地理编码的地址
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if let addr = result.address {
            textFieldAddress.placeholder = addr
        }
        
    }
    
    //输入地址信息，检索地理坐标
    func searchPlaceWithAddrress(addr :String) -> Bool {
        let geoCodeSearchOption: BMKGeoCodeSearchOption  = BMKGeoCodeSearchOption()
        geoCodeSearchOption.address = addr
        let flag = geoCode?.geoCode(geoCodeSearchOption)
        if flag! {
            print("检索成功")
            return true
        } else {
            print("检索失败")
            return false
        }
    }
    
    //查到地理坐标的代理
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if (error == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
//            let point = mapView?.convert(result.location, toPointTo: self.view)
//            self.view.center = point!
            
            
            mapView?.setCenter(result.location, animated: true)
        }
        else {
            print("未找到结果")
            self.showOneButtonDialog(title: "Error", description: "未找到你要查询的地址")
        }
    }
    
    // #MARK: 查询输入框判断
    func listenAddressTextFiledInput() {
        self.textFieldAddress.delegate = self
        self.textFieldAddress.returnKeyType = .search
        
        //创建一个 判断是否是有效地址的 textfiled 监控信号
        let isValidAddressSignal = self.textFieldAddress.reactive.continuousTextValues.map({
            inputText in
            return self.isValidAddress(addr: inputText!)
        })
        
        //为信号添加观察者,由是否有效得到字体颜色，从而设置字体颜色
        isValidAddressSignal.map({
            isValid in            
            
            return isValid ? UIColor.black : UIColor.red
        }).observeValues ({ (textColor) in
            self.textFieldAddress.textColor = textColor
        })
        
    }
    
    func isValidAddress(addr :String) -> Bool {
        return (addr.utf16.count) > 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchPlaceWithAddrress(addr: textField.text!)
        return true
    }
}
