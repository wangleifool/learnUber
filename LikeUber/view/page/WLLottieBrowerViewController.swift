//
//  WLLottieBrowerViewController.swift
//  LikeUber
//
//  Created by wanglei on 2018/9/7.
//  Copyright © 2018 lei wang. All rights reserved.
//

import UIKit

class WLLottieBrowerViewController: WLBasePageViewController {

    @IBOutlet weak var animationPickerView: UIPickerView!
    var curJsonFile: String?
    lazy var allJsonFIle: [String] = {
        var pathes = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil)
        return pathes.compactMap({ (item) -> String? in
            item.components(separatedBy: "/").last
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func playAnimation(_ sender: Any) {
    }
    @IBAction func changeRepeatPressed(_ sender: Any) {
    }
    @IBAction func loadAnimationFile(_ sender: Any) {
    }
}

extension WLLottieBrowerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allJsonFIle.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allJsonFIle[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        curJsonFile = allJsonFIle[row]
    }
}
