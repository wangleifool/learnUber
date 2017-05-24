//
//  WLCreateAccountViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/22.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLCreateAccountViewController: WLBasePageViewController {

    @IBOutlet weak var textfieldPasswd: UITextField!
    @IBOutlet weak var textfieldPhone: UITextField!
    @IBOutlet weak var textfieldMail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "创建账户"
        setNavigationItem(title: "下一步", selector: #selector(nextStep), isRight: true)
        setNavigationItem(title: "取消", selector: #selector(cancel), isRight: false)
        
        
        textfieldMail.becomeFirstResponder()
    }
    
    func nextStep() {
        let userInfoPage = WLUserInfoViewController()
        self.navigationController?.pushViewController(userInfoPage, animated: true)
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btSelectCountryPressed(_ sender: Any) {
        let vc = WLSelectCountryViewController()
        let navc = UINavigationController(rootViewController: vc)
        self .present(navc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
