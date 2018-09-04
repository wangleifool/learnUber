//
//  WLSublineTextField.swift
//  LikeUber
//
//  Created by lei wang on 2017/11/16.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLSublineTextField: UITextField {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let contextRef:CGContext! = UIGraphicsGetCurrentContext();
        contextRef.setFillColor(UIColor.lightGray.cgColor);        
        contextRef.fill(CGRect(x: 0, y: self.frame.size.height - 8, width: self.frame.size.width, height: 0.5));
    }

    //- (void)drawPlaceholderInRect:(CGRect)rect {
    //    // 计算占位文字的 Size
    //    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
    //                              @{NSFontAttributeName : self.font}];
    //
    //    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
    //     @{NSForegroundColorAttributeName : [UIColor darkGrayColor],
    //       NSFontAttributeName : self.font}];
    //}
    
    override func drawPlaceholder(in rect: CGRect) {
        let placeholderSize:CGSize = (self.placeholder?.size(withAttributes: [NSAttributedStringKey.font: self.font ?? 17.0]))!
        let str:NSString = NSString(string: self.placeholder!)
        str.draw(in: CGRect(x: 0, y: (rect.size.height - placeholderSize.height)/2, width: rect.size.width, height: rect.size.height), withAttributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray,NSAttributedStringKey.font : self.font ?? 17.0])
    }

}
