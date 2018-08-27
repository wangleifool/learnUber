//
//  UIView+Extension.swift
//  LikeUber
//
//  Created by wanglei on 2018/8/27.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }

        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }

        set {
            guard let newColor = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = newColor.cgColor
        }
    }

    @IBInspectable public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }

        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable public var shadowOffset: CGSize {
        get { return layer.shadowOffset }

        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }

        set {
            guard let newColor = newValue else {
                layer.shadowColor = nil
                return
            }
            layer.shadowColor = newColor.cgColor
        }
    }

    @IBInspectable public var shadowOpacity: Float {
        get { return layer.shadowOpacity }

        set {
            layer.shadowOpacity = newValue
        }
    }
}
