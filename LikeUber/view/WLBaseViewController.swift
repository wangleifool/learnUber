//
//  WLBaseViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import Hero
import RxSwift
import RxCocoa

class WLBaseViewController: UIViewController {
    var baseDisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
//            .subscribe(onNext: { [weak self] (notification) in
//                self?.keyboardWillShow(note: notification)
//            })
//            .disposed(by: baseDisposeBag)
//
//        NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
//            .subscribe(onNext: { [weak self] (notification) in
//                self?.keyboardWillHide(note: notification)
//            })
//            .disposed(by: baseDisposeBag)
    }

    @objc func keyboardWillShow(note: Notification) {
        guard let userInfo: NSDictionary = note.userInfo as NSDictionary? else {
            return
        }
        let value = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        guard let keyboardRec = (value as AnyObject).cgRectValue else {
            return
        }

        let height = keyboardRec.size.height

        var distance: CGFloat = height - self.view.frame.height
        if self.navigationController == nil {
            distance = height - self.view.frame.height
        } else {
            var tabbarHeight: CGFloat = 0
            if self.tabBarController != nil {
                tabbarHeight = Const.tabbarHeight
            }
            var navbarHeight: CGFloat = 0
            if self.navigationController != nil {
                navbarHeight = Const.navBarAndStatusBarHeight
            }
            distance = height - (self.view.frame.height - tabbarHeight - navbarHeight)
        }

        guard self.view.frame.origin.y == 0 else { return }
        var frame = view.frame
        frame.origin.y -= CGFloat(fabsf(Float(distance)))
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.frame = frame
        })
    }

    @objc func keyboardWillHide(note: Notification) {
        var frame = view.frame
        frame.origin.y = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.frame = frame
        })
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
