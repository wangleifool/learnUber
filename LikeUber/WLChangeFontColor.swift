//
//  WLChangeFontColor.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/5.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

class WLChangeFontColor: UIViewController {

    @IBOutlet weak var btChangeFont: UIButton!
    @IBOutlet weak var mainTextView: UITextView!
    
    var fontNames = ["MFTongXin_Noncommercial-Regular", "MFJinHei_Noncommercial-Regular", "MFZhiHei_Noncommercial-Regular", "Gaspar Regular"]
    var fontIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btChangeFont.layer.cornerRadius = btChangeFont.frame.width/2
        btChangeFont.clipsToBounds = true
        
        mainTextView.font = UIFont(name: fontNames[fontIndex], size: 16)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func changeFontClicked(_ sender: Any) {
        fontIndex = (fontIndex + 1) % fontNames.count
        let font = UIFont(name: fontNames[fontIndex], size: 16)
        mainTextView.font = font
    }
    
}
