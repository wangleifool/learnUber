//
//  WLHomePage-CustomMenu.swift
//  LikeUber
//
//  Created by lei wang on 2017/11/9.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import Foundation

//自定义translation 转场
extension WLHomePageViewController : UIViewControllerTransitioningDelegate {
    
    @objc func btShowMenuPressed(sender: UIButton) {
        //得到父级视图控制器drawerController
        //        if let drawerController = appDelegate?.window?.rootViewController as? KYDrawerController {
        //            if drawerController.drawerState == .closed {
        //                drawerController.setDrawerState(.opened, animated: true)
        //            } else {
        //                drawerController.setDrawerState(.closed, animated: true)
        //            }
        //        }
        
//        let menuViewController = WLMenuViewController(nibName: "WLMenuViewController", bundle: Bundle.main)
//        menuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        menuViewController.modalPresentationStyle = .custom
//        menuViewController.transitioningDelegate = self
//        
//        //提供转场动画需要的参数
//        self.presentationAnimator.animationDelegate = menuViewController as GuillotineAnimationDelegate
//        self.presentationAnimator.supportView = self.navigationController?.navigationBar  //该定制转场动画是基于导航栏条的一个效果重叠的旋转效果
//        self.presentationAnimator.presentButton = sender  //指定 启动 旋转转场动画的按钮
//        
//        present(menuViewController, animated: true, completion: nil) //转场
    }
    
    // #MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presentationAnimator.mode = .presentation
        return self.presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presentationAnimator.mode = .dismissal
        return self.presentationAnimator
    }
    
}
