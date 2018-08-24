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

class SuccessAlertView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    private let disposeBag = DisposeBag()
    private let viewAniamteTime: TimeInterval = 0.3
    var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }

    static func instance() -> SuccessAlertView {
        if let view = Bundle.main.loadNibNamed("SuccessAlertView",
                                            owner: self,
                                            options: nil)?.first as? SuccessAlertView {
            view.frame = UIScreen.main.bounds
            view.closeButton.rx.tap
                .subscribe(onNext: {
                    view.hide()
                })
                .disposed(by: view.disposeBag)
            return view
        }
        return SuccessAlertView()
    }

    func show() {
        // Simple view show animation
        alpha = 0
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)
        UIView.animate(withDuration: viewAniamteTime) { [weak self] in
            self?.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: viewAniamteTime,
                       animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
