//
//  WLPhotoSelectCollectionViewCell.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/24.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

class WLPhotoSelectCollectionViewCell: UICollectionViewCell {

    var representedIdentifier: String! //用于独立标记每个cell
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code                
    }

    
    
    
    @IBAction func photoSelectClicked(_ sender: Any) {
        if let btSelect = sender as? UIButton {
            if btSelect.tag == 0 {
                btSelect.tag = 1
                btSelect.setImage(UIImage(named:"photoSelect"), for: .normal)
            } else {
                btSelect.tag = 0
                btSelect.setImage(UIImage(named:"photoNotSelect"), for: .normal)
            }
        }
    }
}
