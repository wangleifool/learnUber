//
//  WLBaseViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setNavigationItem(title:String,selector:Selector,isRight:Bool) {
        var barButtonItem:UIBarButtonItem
        
        if title.hasSuffix("png") {
            let btMenu = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            btMenu.setImage(UIImage(named:title), for: UIControlState.normal)
            btMenu.addTarget(self, action: selector, for: UIControlEvents.touchUpInside)
            barButtonItem = UIBarButtonItem(customView: btMenu)
//            barButtonItem = UIBarButtonItem(image: UIImage(named:title), style: .plain, target: self, action: selector)
        } else {
            barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        }
        
        if isRight {
            self.navigationItem.rightBarButtonItem = barButtonItem
        } else {
            self.navigationItem.leftBarButtonItem  = barButtonItem
        }
    }
    
    
    //base function
    func showOneButtonDialog(title: String, description: String) {
        let alertController :UIAlertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
        self.present(alertController, animated: true, completion: nil)
    }

}
