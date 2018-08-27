import UIKit

class DrawerViewController: UIViewController {
    var cellModels: [WLSettingsCellModels] = {
        let setThemeCell = WLSettingsCellModels(titleName: "主题", canExpand: true, destVC: WLChangeFontColor.self)
        let userInfoCell = WLSettingsCellModels(titleName: "个人信息", canExpand: true, destVC: WLUserInfoViewController.self)
        let advanceCell = WLSettingsCellModels(titleName: "高级", canExpand: true, destVC: nil)
        return [setThemeCell, userInfoCell, advanceCell]
    }()
    let headerFrame = CGRect(x: 0, y: 0, width: Const.screenWidth * 305/375, height: 120)
    @IBOutlet weak var tableView: UITableView!
    var advanceCellModel = ["高级": [WLSettingsCellModels(titleName: "开始计时", destVC: WLTimeCounterViewController.self),
                                       WLSettingsCellModels(titleName: "附近店铺", destVC: nil),
                                    WLSettingsCellModels(titleName: "关于App", destVC: nil)]]

    override func viewDidLoad() {
        super.viewDidLoad()

        if let headerView = Bundle.main.loadNibNamed("WLDrawerHeaderView", owner: nil, options: nil)?.first as? WLDrawerHeaderView {
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
        }
        let footerView = UIView()
        tableView.tableFooterView = footerView
    }

    private func setupView() {
        
    }

    /// 更新数据源
    ///
    /// - Parameter indexPath: 输入当前点击的cell条目index
    /// - Returns: 需要增加或删除的所有cell的index
    func updateDatasource(indexPath: IndexPath) -> ([WLSettingsCellModels], [IndexPath])? {
        let curCellItem = cellModels[indexPath.row]
        guard curCellItem.canExpand,
            let subData = advanceCellModel[curCellItem.title] else {
                return nil
        }
        var needUpdateIndexes = [IndexPath]()
        // 创建新插入数据的indexpath
        for i in 1...subData.count {
            let newIndex = IndexPath(row: indexPath.row + i, section: indexPath.section)
            needUpdateIndexes.append(newIndex)
        }
        return (subData, needUpdateIndexes)
    }
}

extension DrawerViewController: UITableViewDataSource {
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
            cell?.backgroundColor = UIColor.clear
        }

        let model = cellModels[indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.textLabel?.textColor = model.canExpand ? UIColor.black : UIColor.lightGray

        if let icon = model.icon {
            cell?.imageView?.image = UIImage(named: icon)
        }

        if let value = model.value {
            cell?.detailTextLabel?.text = value
        }

        return cell!
    }
}

extension DrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellItem = cellModels[indexPath.row]
        if let vcType = cellItem.destViewController {
            let targetVC = vcType.init()
            self.present(targetVC, animated: true, completion: nil)
            if let drawerController = parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: false)
            }
            return
        }




        switch indexPath.row {
//        case 0:
//            let changeThemeVC = WLChangeFontColor()
//            self.present(changeThemeVC, animated: true, completion: nil)
//            if let drawerController = parent as? KYDrawerController {
//                drawerController.setDrawerState(.closed, animated: false)
//            }
//        case 1:
//            let userInfoVC = WLUserInfoViewController()
//            self.present(userInfoVC, animated: true, completion: nil)
//            if let drawerController = parent as? KYDrawerController {
//                drawerController.setDrawerState(.closed, animated: false)
//            }
        case 2:
            if let updatedDataTuple = updateDatasource(indexPath: indexPath) {
                let curCellItem = cellModels[indexPath.row]
                // 当前已经展开，需要关闭
                if curCellItem.isExpand {
                    curCellItem.isExpand = false
                    cellModels.removeSubrange(indexPath.row + 1...indexPath.row + updatedDataTuple.0.count)
                    tableView.deleteRows(at: updatedDataTuple.1, with: .right)
                } else { // 需要展开
                    curCellItem.isExpand = true
                    cellModels.insert(contentsOf: updatedDataTuple.0, at: indexPath.row + 1)
                    tableView.insertRows(at: updatedDataTuple.1, with: .bottom)
                }
            }
        default:
            break
        }

    }
}
