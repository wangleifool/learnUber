//
//  WLSelectCountryViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/22.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLSelectCountryViewController: WLBasePageViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    
    var countrys:[CountryInfo]?
    var headers:[String]?
    var dictDatas:[String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择国家/地区"
        setNavigationItem(title: "取消", selector: #selector(cancel), isRight: false)
//        setNavigationItem(title: "下一步", selector: #selector(nextStep), isRight: true)
        
        initCountry()
        initDatas()
        
        //创建一个重用的单元格
        self.mainTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        
        self.mainTableView.reloadData()
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func nextStep() {
//        
//    }
    
    
    func initCountry()
    {
        let arrCodes =  Locale.isoRegionCodes //获取所以国家代码
        let locale:Locale = Locale.current
        var info:CountryInfo!
        
        countrys = []
        
        for code in arrCodes {
            
            info = CountryInfo()
            info.code = code
            info.name = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: code)! //通过国家代码获得国家名称
            
            countrys?.append(info)
        }
        
        countrys?.sort(by: {
            (arg1:CountryInfo, arg2:CountryInfo) -> Bool in
            return arg1.name.localizedCaseInsensitiveCompare(arg2.name) == .orderedAscending //中文按照拼音进行排序
            
        })
    }
    
    func initDatas()
    {
        var firstLetter:String!
        var datas:[CountryInfo]!
        
        headers = []
        datas = []
        dictDatas = [:]
        
        for counry in countrys! {
            firstLetter = FxString.firstChineseCharactor(counry.name)
            
            if !(headers!.contains(firstLetter)) {
                if datas.count > 0 {
                    dictDatas![headers!.last!] = datas as AnyObject
                }
                
                headers?.append(firstLetter)
                datas = []
            }
            
            datas.append(counry)
        }
        
        //加上最后一个
        dictDatas![headers!.last!] = datas as AnyObject
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //mainTableView datasource & delegate
    func numberOfSections(in mainTableView: UITableView) -> Int
    {
        return headers!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = headers![section]
        let datas = dictDatas![key] as! [CountryInfo]
        
        return datas.count
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headers![section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        var indexs:[String]=[]
        var char:[CChar]=[0,0]
        
        for i in 65 ..< (65+26) {
            char[0] = CChar(i)
            indexs.append(String(cString: char))
        }
        
        indexs.append("#")
        
        return indexs
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let identify:String = "CellID"
        let cell = mainTableView.dequeueReusableCell(withIdentifier: identify, for: indexPath)
            as UITableViewCell
        
        let key = headers![indexPath.section]
        let datas = dictDatas![key] as! [CountryInfo]
        let country = datas[indexPath.row]
        
        cell.accessoryType = .none
        cell.textLabel?.text = country.name!
        
        return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.mainTableView!.deselectRow(at: indexPath, animated: true)
        
        let cell:UITableViewCell? = self.mainTableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark        
        
        cancel()
    }

}
