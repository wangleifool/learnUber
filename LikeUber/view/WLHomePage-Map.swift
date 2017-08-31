//
//  WLHomePage-Map.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/25.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation

let defaultZoomLevel:Float = 16.0

extension WLHomePageViewController {

    func addBaiduMapView() {
        if mapView == nil {
            mapView = BMKMapView(frame: self.view.bounds)
            self.view.addSubview(mapView!)
            
            //其他设置
            mapView?.showMapScaleBar   = true
            mapView?.zoomLevel = defaultZoomLevel
            mapView?.showMapPoi = true
            
            geoCode = BMKGeoCodeSearch() //地理编码查询
            
            poiSearch = BMKPoiSearch() //热点查询
            
            cloudSearch = BMKCloudSearch() //LBS 云检索
            
            suggestionSearch = BMKSuggestionSearch()
            
            //本地定位
            localService = BMKLocationService()
            localService?.startUserLocationService()
            
            //显示定位图层
            mapView?.showsUserLocation = true
            mapView?.userTrackingMode  = BMKUserTrackingModeHeading
            
            self.perform(#selector(self.btMyLocationPressed(_:)), with: nil, afterDelay: 1.0)
            
        }
        
        
    }
    
    //# MARK: - 推荐查询
    func searchSuggestionPlace(keyWord: String) {
        let suggestOption: BMKSuggestionSearchOption = BMKSuggestionSearchOption()
        
//        suggestOption.cityname = appDelegate!.myLocationRegion
        suggestOption.keyword  = keyWord
        
        let flag = suggestionSearch?.suggestionSearch(suggestOption)
        if flag == true {
            print("推荐地址检索成功")
        } else {
            print("推荐地址检索失败")
        }
        
    }
    
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        if (error == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
            self.suggestionPlaceArray.removeAll()
            
            DispatchQueue.global().async {
                for i in 0 ... result.keyList.count-1 {
                    print("suggest key: \(result.keyList[i]) city: \(result.cityList[i]) district: \(result.districtList[0]) poiID: \(result.poiIdList[i]) coordinate: \(result.ptList[i])")
                    
                    let poiInfo = BMKPoiInfo()
                    poiInfo.name = result.keyList[i] as! String
                    poiInfo.pt   = result.ptList[i]  as! CLLocationCoordinate2D
                    
                    self.suggestionPlaceArray.append(poiInfo)
                }
                
                DispatchQueue.main.async {
                    self.showSuggestionTableView()
                }
            }
        }
        else {
            print("抱歉，未找到结果")
        }
    }
    
    //# MARK: - LBS 云检索
    func searchPlaceByCloud(keyWord:String) {
        let cloudSearchInfo:BMKCloudLocalSearchInfo = BMKCloudLocalSearchInfo()
        /*
         * 本示例代码使用了测试ak和测试数据，开发者在检索自己LBS数据之前，需替换 cloudLocalSearch.ak
         * 和cloudLocalSearch.geoTableId的值
         *
         * 1、替换cloudLocalSearch.ak的值：
         * （1）请访问http://lbsyun.baidu.com/apiconsole/key申请一个“服务端”的ak，其他类型的ak无效；
         * （2）将申请的ak替换cloudLocalSearch.ak的值；
         *
         * 2、替换cloudLocalSearch.geoTableId值：
         * （1）申请完服务端ak后访问http://lbsyun.baidu.com/datamanager/datamanage创建一张表；
         * （2）在“表名称”处自由填写表的名称，如MyData，点击保存；
         * （3）“创建”按钮右方将会出现形如“MyData(34195)”字样，其中的“34195”即为geoTableId的值；
         * （4）添加或修改字段：点击“字段”标签修改和添加字段，然后保存；
         * （5）添加数据：
         *  a、标注模式：“数据” ->“标注模式”，输入要添加的地址然后“百度一下”，点击地图蓝色图标，再点击保存即可；
         *  b、批量模式： “数据” ->“批量模式”，可上传文件导入，具体文件格式要求请参见当页的“批量导入指南”；
         * （6）选择左边“设置”标签，“是否发布到检索”选择“是”，然后"保存";
         * （7）数据发布后，替换cloudLocalSearch.geoTableId的值即可；
         
         * 备注：每创建一张新表后需要选择发布到检索并保存，否则将会出现检索不到数据的情况 
         */
        cloudSearchInfo.ak = "dsx596evyX9lRH7exIh9gcmdtQd9PA2A"
        cloudSearchInfo.geoTableId = 175112
        cloudSearchInfo.pageIndex = 0
        cloudSearchInfo.pageSize = 10
        
        cloudSearchInfo.region = appDelegate?.myLocationRegion
        cloudSearchInfo.keyword = keyWord
        let flag = cloudSearch?.localSearch(with: cloudSearchInfo)
        if flag! {
            print("本地云检索发送成功")
        } else {
            print("本地云检索发送失败")
        }
    }
    
    func onGetCloudPoiResult(_ poiResultList: [Any]!, searchType type: Int32, errorCode error: Int32) {
        // 清楚屏幕中所有的annotation
        let array = mapView?.annotations
        mapView?.removeAnnotations(array)
        
        if (error == 0) {
            let result:BMKCloudPOIList = poiResultList[0] as! BMKCloudPOIList
            print("result: \(result)")
            
        } else {
            print("error == \(error)")
        }
    }
    
    //# MARK: - 显示我的定位
    
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
            mapView?.zoomLevel = defaultZoomLevel
            
            self.curLocation = localService?.userLocation
            
        }
        
    }
    
    // #MARK: - 通过查询poi，显示位置
    func searchByPoiName(name:String) {
        let poiSearchOption:BMKCitySearchOption = BMKCitySearchOption()
        poiSearchOption.keyword = name
        poiSearch?.poiSearch(inCity: poiSearchOption)
        
    }
    
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
        }
        else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
            //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
            // result.cityList;
            print("起始点有歧义")
        } else {
            print("抱歉，未找到结果")
        }
    }
    
    // #MARK: - 通过图钉的位置，反馈地址信息
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        //图钉的针尖放在self.view.center位置
        let point = mapView?.convert(self.view.center, toCoordinateFrom: self.view)
        self.searchPlaceByCoordinate(coordinate: point!)
        
    }
    
    func searchPlaceByCoordinate(coordinate: CLLocationCoordinate2D) {
        let option = BMKReverseGeoCodeOption()
        option.reverseGeoPoint = coordinate
        
        geoCode?.reverseGeoCode(option)
    }
    
    //代理反馈，查询到反地理编码的地址
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
            
        //如果是要收集 推荐的地址信息，逻辑和其他代码无关
        if isReverseGeoFromShwoSuggestionPlace {
            
        } else {
            textFieldStartAddress.text = result?.address
        }
        
//            DispatchQueue.global().async {
//                if result?.poiList != nil {
//                    for poiInfo in result.poiList {
//                        let info = poiInfo as! BMKPoiInfo
//                        
//                        print("poi name: \(info.name) \n poi addr: \(info.address) \n poi phone: \(info.phone) \n poi postcode: \(info.postcode) \n poi type: \(info.epoitype)")
//                        
//                    }
//                }
//            }
            
        
        
    }
    
    // #MARK: 搜索框中输入地址信息，检索地理坐标
    func searchPlaceWithAddrress(addr :String) {
        let geoCodeSearchOption: BMKGeoCodeSearchOption  = BMKGeoCodeSearchOption()
        geoCodeSearchOption.address = addr //输入textfiled中的地址
        
        let flag = geoCode?.geoCode(geoCodeSearchOption)
        if flag! {
            print("检索成功")
        } else {
            print("检索失败")
        }
    }
    
    //查到地理坐标的代理
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if (error == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
//            let point = mapView?.convert(result.location, toPointTo: self.view)
//            self.view.center = point!
            
            //只有起点才会移动图钉
            if isSearchStartAddress {
                mapView?.setCenter(result.location, animated: true)
            }
        }
        else {
            print("未找到结果")
            self.showOneButtonDialog(title: "Error", description: "未找到你要查询的地址")
        }
    }
    
    // #MARK: 监控地址输入框
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        self.searchPlaceWithAddrress(addr: textField.text!)
        //        self.searchByPoiName(name: textField.text!)
        //        self.searchPlaceByCloud(keyWord: textField.text!)
        self.searchSuggestionPlace(keyWord: textField.text!)
        
        if textField == textFieldStartAddress {
            self.isSearchStartAddress = true
        } else {
            self.isSearchStartAddress = false
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func listenAddressTextFiledInput() {
        self.textFieldTargetAddress.delegate = self
        self.textFieldStartAddress.delegate  = self
        self.textFieldStartAddress.returnKeyType  = .search
        self.textFieldTargetAddress.returnKeyType = .search
        
        //创建一个 判断是否是有效地址的 textfiled 监控信号
        let isValidAddressSignal = self.textFieldTargetAddress.reactive.continuousTextValues.map({
            inputText in
            return self.isValidAddress(addr: inputText!)
        })
        
        //为信号添加观察者,由是否有效得到字体颜色，从而设置字体颜色
        isValidAddressSignal.map({
            isValid in            
            
            if isValid {
                self.searchSuggestionPlace(keyWord: self.textFieldTargetAddress.text!)
            }
            
            return isValid ? UIColor.black : UIColor.red
        }).observeValues ({ (textColor) in
            self.textFieldTargetAddress.textColor = textColor
        })
        
        //创建一个 判断是否是有效地址的 textfiled 监控信号
        let isValidAddressSignalForTextfield1 = self.textFieldStartAddress.reactive.continuousTextValues.map({
            inputText in
            return self.isValidAddress(addr: inputText!)
        })
        
        //为信号添加观察者,由是否有效得到字体颜色，从而设置字体颜色
        isValidAddressSignalForTextfield1.map({
            isValid in
            
            if isValid {
                self.searchSuggestionPlace(keyWord: self.textFieldStartAddress.text!)
            }
            
            return isValid ? UIColor.black : UIColor.red
        }).observeValues ({ (textColor) in
            self.textFieldStartAddress.textColor = textColor
        })
        
    }
    
    func isValidAddress(addr :String) -> Bool {
        return (addr.utf16.count) > 2
    }
    
}
