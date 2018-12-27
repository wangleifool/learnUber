//
//  WLBasePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import RxGesture
import Hero

class WLBasePageViewController: WLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.rx.swipeGesture(.down,
//                             numberOfTouchesRequired: 1,
//                             configuration: nil)
//            .takeUntil(self.rx.deallocated)
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] (_) in
//                self?.doBack()
//            })

//        view.rx.screenEdgePanGesture(edges: UIRectEdge.left)
//            .takeUntil(self.rx.deallocated)
//            .subscribe(onNext: { [weak self] (_) in
//                self?.doBack()
//            })

        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(dealPan(gesture:)))
        edgeGesture.edges = .left
        view.addGestureRecognizer(edgeGesture)

        // 禁止使用系统的 边沿优化 pop 手势, 怕和Hero的转场手势冲突了。
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        hero.isEnabled = true
        hero.modalAnimationType = HeroDefaultAnimationType.zoomSlide(direction: .left)

//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dealPan(gesture:)))
//        view.addGestureRecognizer(panGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dealPan(gesture: UIScreenEdgePanGestureRecognizer ) {
        // calculate the progress based on how far the user moved
        let translation = gesture.translation(in: nil)
        let progress = translation.x / view.bounds.width
        switch gesture.state {
        case .began:
            hero.modalAnimationType = HeroDefaultAnimationType.zoomSlide(direction: .right)
            hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
        default:
            // end the transition when user ended their touchheroModalAnimationType
            if progress + gesture.velocity(in: nil).x / view.bounds.width > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }


    @objc func doBack()
    {
        if (self.navigationController?.viewControllers.count) ?? 0  > 1 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
