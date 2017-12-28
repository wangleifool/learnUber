//
//  WLUserInfoViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/22.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit

class WLUserInfoViewController: WLBasePageViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userHeadImage: UIImageView!
    @IBOutlet weak var textFieldSurName: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "建立基本资料"
        setNavigationItem(title: "下一步", selector: #selector(nextStep), isRight: true)

        textFieldSurName.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func nextStep() {
        
    }

    @IBAction func userHeadImageDidPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        

        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Choose from album", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Choose from camera", style: .default, handler: { (action) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
           
        }))
        
        
        self.present(alertSheet, animated: true, completion: nil)
        
        
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userHeadImage.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        picker .dismiss(animated: true, completion: nil)
    }

}
