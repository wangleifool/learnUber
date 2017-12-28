//
//  WLMenuViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/11/9.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit


//协议GuillotineMenu 是需要我们提供Title 和 Dismiss button
class WLMenuViewController: UIViewController,GuillotineAnimationDelegate,GuillotineMenu {
    var dismissButton: UIButton? //GuillotineMenu协议需要提供的 dismiss 按钮
    var titleLabel: UILabel? //GuillotineMenu协议需要提供的 title label
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "UBER"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutSubviews()
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    // #MARK: GuillotineAnimationDelegate 监控转场动画过程
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
    
    // #MARK: action
    @IBAction func btCloseClicked(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
}
