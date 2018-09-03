//
//  SuccessAlertView.swift
//  Renosys
//
//  Created by wanglei on 2018/7/20.
//  Copyright © 2018年 liofty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum AlertAnimationType {
    case zoomInOutCenter
    case slideFromBottom
    case slideFromTop
}

class SuccessAlertView: UIView {


    @IBOutlet weak var backCoverView: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    private let disposeBag = DisposeBag()
    private let viewAniamteTime: TimeInterval = 0.3
    private var animationType: AlertAnimationType = .zoomInOutCenter
    var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }

    static func instance(animationType: AlertAnimationType = .zoomInOutCenter) -> SuccessAlertView {
        if let view = Bundle.main.loadNibNamed("SuccessAlertView",
                                            owner: self,
                                            options: nil)?.first as? SuccessAlertView {
            view.frame = UIScreen.main.bounds
            Observable.of(view.closeButton.rx.tap,
                          view.backCoverView.rx.tap)
                .merge()
                .subscribe(onNext: {
                    view.hide()
                })
                .disposed(by: view.disposeBag)
            view.animationType = animationType
            return view
        }
        return SuccessAlertView()
    }

    func show() {
        // Simple view show animation
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)
        backCoverView.alpha = 0
        alertView.alpha = 0

        switch animationType {
        case .zoomInOutCenter:
            alertView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            UIView.animate(withDuration: viewAniamteTime,
                           animations: { [weak self] in
                                self?.alertView.alpha = 1
                                self?.backCoverView.alpha = 1
                                self?.alertView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) { [weak self] _ in
                UIView.animate(withDuration: self?.viewAniamteTime ?? 0.3,
                               delay: 0,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: { [weak self] in
                                self?.alertView.transform = CGAffineTransform.identity
                }, completion: nil)
            }
//            UIView.animate(withDuration: viewAniamteTime) { [weak self] in
//                self?.alertView.alpha = 1
//                self?.backCoverView.alpha = 1
//                self?.alertView.transform = CGAffineTransform.identity
//            }

//            UIView.animate(withDuration: viewAniamteTime,
//                           delay: 0,
//                           usingSpringWithDamping: 1,
//                           initialSpringVelocity: 0.5,
//                           options: .allowAnimatedContent,
//                           animations: { [weak self] in
//                                self?.alertView.alpha = 1
//                                self?.backCoverView.alpha = 1
//                                self?.alertView.transform = CGAffineTransform.identity
//            }, completion: nil)
        case .slideFromBottom:
            alertView.alpha = 1
            let scale = CGAffineTransform(scaleX: 0.1, y: 0.1)
            let translate = CGAffineTransform(translationX: 0, y: ScreenHeight - alertView.frame.y)
            alertView.transform = scale.concatenating(translate)
            UIView.animate(withDuration: viewAniamteTime,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: { [weak self] in
                            self?.alertView.transform = CGAffineTransform.identity
                            self?.backCoverView.alpha = 1
            }, completion: nil)
        default:
            break
        }

    }

    func hide() {
        switch animationType {
        case .zoomInOutCenter:
            UIView.animate(withDuration: viewAniamteTime,
                           animations: { [weak self] in
                            self?.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                            self?.backCoverView.alpha = 0
            }) { [weak self] _ in
                self?.removeFromSuperview()
            }
        case .slideFromBottom:
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { [weak self] in
                            let translate = CGAffineTransform(translationX: 0, y: 600.0)
                            let scale = CGAffineTransform(scaleX: 0.01, y: 0.01)
                            self?.alertView.transform = scale.concatenating(translate)
                            self?.backCoverView.alpha = 0
                }, completion: { [weak self] _ in
                    self?.removeFromSuperview()
            })
        default:
            break
        }
    }
}
