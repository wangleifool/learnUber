//
//  WLUserInfoViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/22.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

class WLUserInfoViewController: WLBasePageViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WLPhotoSelectViewControllerDelegate {

    @IBOutlet weak var userHeadImage: UIImageView!
    @IBOutlet weak var textFieldSurName: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    var animator : ARNTransitionAnimator!
    var photoSelectVC:WLPhotoSelectViewController!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "建立基本资料"
        setNavigationItem(title: "下一步", selector: #selector(nextStep), isRight: true)

        setNavigationItem(title: "跳过", selector: #selector(skip), isRight: false)
        
//        textFieldSurName.becomeFirstResponder()
        
        
        photoSelectVC = WLPhotoSelectViewController()
        photoSelectVC.delegate = self
        photoSelectVC.modalPresentationStyle = .overFullScreen
        
        setupAnimator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupAnimator() {
        let animation = interactiveTransition(sourceVC: self.navigationController!, destVC: self.photoSelectVC)
        animation.completion = { [weak self] isPresenting in
            if isPresenting {
                guard let _self = self else { return }
                let modalGestureHandler = TransitionGestureHandler(targetView: _self.photoSelectVC.photoCollectionView, direction: .bottom)//TransitionGestureHandler(targetVC: _self, direction: .bottom)
//                modalGestureHandler.registerGesture(_self.photoSelectVC.view)
                modalGestureHandler.panCompletionThreshold = 15.0
                _self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: modalGestureHandler)
            } else {
                self?.setupAnimator()
            }
        }
//        let gestureHandler = TransitionGestureHandler(targetView: self.photoSelectVC.photoCollectionView, direction: .bottom)
//        gestureHandler.panCompletionThreshold = 15.0
        
        self.animator = ARNTransitionAnimator(duration: 0.5, animation: animation)
//        self.animator?.registerInteractiveTransitioning(.dismiss, gestureHandler: gestureHandler)
        
        self.photoSelectVC.transitioningDelegate = self.animator
    }
    
    @objc func nextStep() {
        let createAccountPage = SignUpViewController()
        
        self.navigationController?.pushViewController(createAccountPage, animated: true)
    }
    
    @objc func skip() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func userHeadImageDidPressed(_ sender: Any) {
        
        
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
      
        photoSelectVC.resetToDefault()
        self.present(photoSelectVC, animated: true, completion: nil)
//        imagePicker.delegate = self;
//
//
//        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alertSheet.addAction(UIAlertAction(title: "从相册选择", style: .default, handler: { (action) in
//            self.imagePicker.sourceType = .photoLibrary
//            self.imagePicker.allowsEditing = true
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//
//        alertSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
//            self.imagePicker.sourceType = .camera
//            self.imagePicker.allowsEditing = true
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }))
//
//        alertSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
//
//        }))
//
//
//        self.present(alertSheet, animated: true, completion: nil)
        
        
    }
   
//    // 当得到照片或者视频后，调用该方法
//    -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    NSLog(@"Picker returned successfully.");
//    NSLog(@"%@", info);
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    // 判断获取类型：图片
//    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
//    UIImage *theImage = nil;
//    // 判断，图片是否允许修改
//    if ([picker allowsEditing]){
//    //获取用户编辑之后的图像
//    theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    } else {
//    // 照片的原数据
//    theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
//    // 保存图片到相册中
//    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
//    UIImageWriteToSavedPhotosAlbum(theImage, self,selectorToCall, NULL);
//
//    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
//    // 判断获取类型：视频
//    //获取视频文件的url
//    NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
//    //创建ALAssetsLibrary对象并将视频保存到媒体库
//    // Assets Library 框架包是提供了在应用程序中操作图片和视频的相关功能。相当于一个桥梁，链接了应用程序和多媒体文件。
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    // 将视频保存到相册中
//    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL
//    completionBlock:^(NSURL *assetURL, NSError *error) {
//    if (!error) {
//    NSLog(@"captured video saved with no error.");
//    }else{
//    NSLog(@"error occured while saving the video:%@", error);
//    }
//    }];
//    }
//    [picker  dismissViewControllerAnimated:YES completion:nil];
//    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if self.imagePicker.allowsEditing {
            userHeadImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        } else {
            userHeadImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        picker .dismiss(animated: true, completion: nil)
    }
    
    func afterDoneGetImages(images: Array<UIImage>) {
        userHeadImage.image = images[0]
    }

}
