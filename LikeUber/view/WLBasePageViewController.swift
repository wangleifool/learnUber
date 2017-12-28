//
//  WLBasePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLBasePageViewController: WLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func doBack()
    {
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func showAlertView(title :String, message :String) {
        
        
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default,
                                     handler: {
                                        action in
                                        
        })
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}
