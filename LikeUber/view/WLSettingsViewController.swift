//
//  WLSettingsViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/24.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLSettingsViewController: WLBasePageViewController,UITableViewDataSource,UITableViewDelegate {
    
    var cellModels:[WLSettingsCellModels] {
        let setThemeCell = WLSettingsCellModels(iconName: nil, titleName: "主题", valueName: nil)
        let userInfoCell = WLSettingsCellModels(iconName: nil, titleName: "个人信息", valueName: nil)
        
        return [setThemeCell,userInfoCell]
    }
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setNavigationItem(title: "Close.png", selector: #selector(self.doBack), isRight: false)

    }

    // MARK: tableView data source delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "settingCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        let model = cellModels[indexPath.row]
        cell?.textLabel?.text = model.title
        
        if let icon = model.icon {
            cell?.imageView?.image = UIImage(named: icon)
        }
        
        if let value = model.value {
            cell?.detailTextLabel?.text = value
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let changeThemeVC = WLChangeFontColor()
            self.navigationController?.pushViewController(changeThemeVC, animated: true)
        case 1:
            let userInfoVC = WLUserInfoViewController()
            self.navigationController?.pushViewController(userInfoVC, animated: true)
        default:
            print("")
        }
        
    }
}
