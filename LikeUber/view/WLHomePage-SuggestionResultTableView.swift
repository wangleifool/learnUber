//
//  WLHomePage-SuggestionResultTableView.swift
//  LikeUber
//
//  Created by lei wang on 2017/8/31.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation

extension WLHomePageViewController :UITableViewDataSource,UITableViewDelegate {
    
    func setupSuggestionPlaceTableView() {
        self.view.addSubview(suggestionPlaceTableView)
        self.view.bringSubview(toFront: suggestionPlaceTableView)
        suggestionPlaceTableView.dataSource = self
        suggestionPlaceTableView.delegate   = self
        
        suggestionPlaceTableView.keyboardDismissMode = .onDrag
        let footerView = UIView()
        suggestionPlaceTableView.tableFooterView = footerView
        
        suggestionPlaceTableView.isHidden = true
    }
    
    func hideTableView() {
        UIView.animate(withDuration: 0.5) { 
            self.suggestionPlaceTableView.isHidden = true
        }
    }
    
//    func showSuggestionTableView(fromView: UIView) {
    func showSuggestionTableView() {
        var frame = textFieldTargetAddress.superview!.frame  //先获取触发显示 tableView 的控件 位置
        
        frame.origin.y += (frame.height + 16) //16 是两个视图之间的间隙
        frame.size.height = ScreenHeight - frame.origin.y - 16 //16 是tableView 举例底部的间隙
        
        suggestionPlaceTableView.frame = frame
        
        UIView.animate(withDuration: 0.5) { 
            self.suggestionPlaceTableView.isHidden = false
        }
        
        suggestionPlaceTableView.reloadData()
    }
    
    // #MARK: - tableview datasource & delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestionPlaceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.创建cell：
        let CellID = "CellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID)
        
        if cell == nil {
            // 在swift中使用枚举: 1> 枚举类型.具体的类型 2> .具体的类型
            cell = UITableViewCell(style: .default, reuseIdentifier: CellID)
        }
        
        // 2.给cell设置数据:cell为可选类型，从缓存池中取出的cell可为空，所以为可选类型,最后返回cell的时候要进行强制解包，此时已经保证了可选类型不为空，若为空强制解包会为空
        
        let placeInfo: BMKPoiInfo = self.suggestionPlaceArray[indexPath.row]
        cell?.textLabel?.text = placeInfo.name
        
        // 3.返回cell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了:\((indexPath as NSIndexPath).row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let placeInfo: BMKPoiInfo = self.suggestionPlaceArray[indexPath.row]
        
        if self.isSearchStartAddress {
            mapView?.setCenter(placeInfo.pt, animated: true)
            self.textFieldStartAddress.text = placeInfo.name
            self.startPoiPlace = placeInfo
        } else {
            self.textFieldTargetAddress.text = placeInfo.name
            self.targetPoiPlace = placeInfo
            self.startSchemRoute()
        }
        
        self.hideVirtualKeyBoard()
        self.hideTableView()        
    }
    
}
