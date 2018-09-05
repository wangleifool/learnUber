//
//  WLAnimationTableViewController.swift
//  LikeUber
//
//  Created by wanglei on 2018/9/5.
//  Copyright © 2018 lei wang. All rights reserved.
//

import UIKit

class WLAnimationTableViewController: WLBasePageViewController {

    @IBOutlet weak var mainTableView: UITableView!
    private let cellIdentifier = "Cell"
    var animationType: AnimationType = .verticalDelayShow
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.rowHeight = 64.0
        mainTableView.separatorStyle = .none
        mainTableView.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showVisiableCellAnimation()
    }

    @IBAction func closePage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func showVisiableCellAnimation() {
        let cells = mainTableView.visibleCells
        let tableViewHeight = mainTableView.bounds.height
        // 将可视的cell移到屏幕外
        for cell in cells {
            if animationType == .verticalDelayShow {
                cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            } else {
                cell.transform = CGAffineTransform(translationX: ScreenWidth, y: 0)
            }
        }
        mainTableView.alpha = 1 // 不再隐藏tableview
        let diff = 0.1 // 每个cell进场的间隔
        for i in 0 ..< cells.count {
            let cell = cells[i]

            UIView.animate(withDuration: 1.0,
                           delay: Double(i) * diff,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0,
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: {
                            cell.transform = CGAffineTransform.identity
            },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WLAnimationTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        cell?.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        return cell!
    }
}
