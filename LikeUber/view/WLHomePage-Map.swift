//
//  WLHomePage-Map.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/25.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation

let defaultZoomLevel:Float = 18.0

extension WLHomePageViewController: BMKRouteSearchDelegate {

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
            
            
            //路径规划相关
            driverRouteSearch = BMKRouteSearch()
        }
        
        
    }
    
    func addAllMapServiceDelegate() {
        localService?.delegate = self
        mapView?.delegate = self
        geoCode?.delegate = self
        poiSearch?.delegate = self
        cloudSearch?.delegate = self
        suggestionSearch?.delegate = self
        driverRouteSearch.delegate = self
    }
    
    func removeAllMapServiceDelegate() {
        mapView?.delegate = nil
        geoCode?.delegate = nil
        poiSearch?.delegate = nil
        cloudSearch?.delegate = nil
        suggestionSearch?.delegate = nil
        localService?.delegate = nil
        driverRouteSearch.delegate = nil
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
//        if ((localService?.userLocation.location) != nil)        {
        if let location = localService?.userLocation.location {
            mapView?.setCenter(location.coordinate, animated: true)
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
        
        //只有当用户还没有打车的时候，可以使用随时移动 锁定起点的功能
        if self.driver != nil {
            if self.driver!.state == .driveToAnywhere {
                //图钉的针尖放在self.view.center位置
                let point = mapView?.convert(self.view.center, toCoordinateFrom: self.view)
                self.searchPlaceByCoordinate(coordinate: point!)
                
                self.btTuding.isHidden = false
            } else {
                self.btTuding.isHidden = true
            }
        } else {
            //图钉的针尖放在self.view.center位置
            let point = mapView?.convert(self.view.center, toCoordinateFrom: self.view)
            self.searchPlaceByCoordinate(coordinate: point!)
        }
        
        
        
    }
    
    func searchPlaceByCoordinate(coordinate: CLLocationCoordinate2D) {
        let option = BMKReverseGeoCodeOption()
        option.reverseGeoPoint = coordinate
        
        geoCode?.reverseGeoCode(option)
    }
    
    //代理反馈，查询到反地理编码的地址
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        if result == nil {
            return
        }
        
        //如果是要收集 推荐的地址信息，逻辑和其他代码无关
        if isReverseGeoFromShwoSuggestionPlace {
            
        } else {
            //记录查询的地址信息
            let poiInfo = BMKPoiInfo()
            poiInfo.name = result?.sematicDescription
            poiInfo.address = result?.address
            poiInfo.pt   = (result?.location)!
            
            textFieldStartAddress.text = result?.sematicDescription
            self.startPoiPlace = poiInfo
            
            let annotationArray = self.mapView?.annotations
            self.mapView?.removeAnnotations(annotationArray)
            self.showNearbyDrivers() //显示附近的车辆
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
    
    // #MARK: - 路径规划
    func carRouteSearch(start: BMKPoiInfo, target: BMKPoiInfo) {
        let from = BMKPlanNode()
        from.name = start.name
        from.pt   = start.pt
        from.cityName = start.city
        
        let to = BMKPlanNode()
        to.name = target.name
        to.pt   = target.pt
        to.cityName = target.city
        
        let drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = from
        drivingRouteSearchOption.to = to
        drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE//不获取路况信息
        
        let flag = driverRouteSearch.drivingSearch(drivingRouteSearchOption)
        if flag {
            print("驾乘检索发送成功")
        }else {
            print("驾乘检索发送失败")
        }
    }
    
    /**
     *返回驾乘搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKDrivingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetDrivingRouteResult: \(error)")
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKDrivingRouteLine
            
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKDrivingStep
                if i == 0 {
                    let item = WLAnnotation()
                    item.coordinate = plan.starting.location
                    item.title = "起点"
                    item.type = 0
                    mapView.addAnnotation(item)  // 添加起点标注
                }
                if i == size - 1 {
                    let item = WLAnnotation()
                    item.coordinate = plan.terminal.location
                    item.title = "终点"
                    item.type = 1
                    mapView.addAnnotation(item)  // 添加终点标注
                }
                
                // 添加 annotation 节点
                let item = WLAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapView.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 添加途径点
            if plan.wayPoints != nil {
                for tempNode in plan.wayPoints as! [BMKPlanNode] {
                    let item = WLAnnotation()
                    item.coordinate = tempNode.pt
                    item.type = 5
                    item.title = tempNode.name
                    mapView.addAnnotation(item)
                }
            }
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            // 添加路线 overlay
            mapView.add(polyLine)
//            mapViewFitPolyLine(polyLine)
            
            //开始启程
            startDriveToTargetPlace(routeLine: polyLine!)
        }
    }
    
    
    //根据polyline设置地图范围
    func mapViewFitPolyLine(_ polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var leftTopX = pt.x
        var leftTopY = pt.y
        var rightBottomX = pt.x
        var rightBottomY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
            leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
            rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
            rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
        }
        
        let rect = BMKMapRectMake(leftTopX, leftTopY, rightBottomX - leftTopX, rightBottomY - leftTopY)
        mapView.visibleMapRect = rect
    }
    
    /**
     *根据overlay生成对应的View
     *@param mapView 地图View
     *@param overlay 指定的overlay
     *@return 生成的覆盖物View
     */
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = UIColor(red: 42/255.0, green: 166/255.0, blue: 92/255.0, alpha: 0.7)
            polylineView?.lineWidth = 3
            
            return polylineView
        }
        return nil
    }

    
    // #MARK: - 监控地址输入框
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
    
    func hideVirtualKeyBoard() {
        self.textFieldStartAddress.resignFirstResponder()
        self.textFieldTargetAddress.resignFirstResponder()
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
            
            self.isSearchStartAddress = false
            
            //如果是选择了 推荐的地址 导致的textfiled文本内容发生变化，不要再搜索地址了
            if self.isSelectFromSuggestChoices {
                self.isSelectFromSuggestChoices = false
                return isValid ? UIColor.black : UIColor.red
            }
            
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
            
            self.isSearchStartAddress = true
            
            //如果是选择了 推荐的地址 导致的textfiled文本内容发生变化，不要再搜索地址了
            if self.isSelectFromSuggestChoices {
                self.isSelectFromSuggestChoices = false
                return isValid ? UIColor.black : UIColor.red
            }
            
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
