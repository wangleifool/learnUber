//
//  WLGuidePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import AVFoundation

class WLGuidePageViewController: WLBasePageViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btLogin: TKTransitionSubmitButton!
    
    var videoPlayer:AVPlayer!
    var playerItem:AVPlayerItem!
    var location:WLLocation!
    var appDelegate:AppDelegate?
    var isCreated:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if location == nil {
            location = WLLocation()
            location.startLocation()
        }

    }
    
    override func viewDidLayoutSubviews() {
        
        if !isCreated {
            isCreated = true
            
            initGuideVideoPlayer()
            showGuideAnimation()
        }
    }
    
    //启动动画
    func showGuideAnimation() {
        var images:[UIImage] = [] //装图片的数组
        var imageName:String
        
        for i in 0 ... 67 {
            imageName = "logo-"+String(format: "%03d",i);
            images.insert(UIImage(named: imageName)!, at: i)
        }
        
        self.backgroundImageView.animationImages = images
        self.backgroundImageView.animationDuration = 3.0
        self.backgroundImageView.animationRepeatCount = 1
        
        self.backgroundImageView.startAnimating()
        
        //过渡动画
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 1.0
            self.videoPlayer.play()
        }, completion: nil)
    }
    
    //初始化视频层
    func initGuideVideoPlayer() {
        let videoPath = Bundle.main.path(forResource: "welcome_video", ofType: "mp4")
        playerItem  = AVPlayerItem(url: URL(fileURLWithPath: videoPath!))
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.frame = self.backView.bounds
        videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        self.backView.layer.insertSublayer(videoPlayerLayer, at: 0) //插在最根部
        self.backView.alpha = 0.0 //初始情况，backview不可见，当启动动画结束，则可以显示并播放视频
        
        
        //swift 3.0 的 selector写法真是!!!  监控播放结束事件
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayDidEnd(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func videoPlayDidEnd(sender: Notification) {
        let item = sender.object as! AVPlayerItem
        item.seek(to: kCMTimeZero)
        self.videoPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    @IBAction func btRegisterPressed(_ sender: Any) {
        let createAccountPage = WLCreateAccountViewController()
        let nav = UINavigationController(rootViewController: createAccountPage)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btLoginPressed(_ sender: Any) {

//        appDelegate?.showHomePage()
        
        //登录按钮的动画，按钮扩展全面视图
        btLogin.animate(0.6) {
            let homePage = WLHomePageViewController()
            let nav = UINavigationController(rootViewController: homePage)
            nav.transitioningDelegate = self
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    

    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
