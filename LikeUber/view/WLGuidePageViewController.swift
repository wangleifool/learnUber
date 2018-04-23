//
//  WLGuidePageViewController.swift
//  LikeUber
//
//  Created by lei wang on 2017/5/19.
//  Copyright © 2017年 lei wang. All rights reserved.
//

import UIKit
import AVFoundation
import RxCocoa
import RxSwift


class WLGuidePageViewController: WLBasePageViewController,UIViewControllerTransitioningDelegate,UITextFieldDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btLogin: TKTransitionSubmitButton!
    @IBOutlet weak var textfieldUserName: WLSublineTextField!
    @IBOutlet weak var textfieldPasswd: WLSublineTextField!
    @IBOutlet weak var usernameHintLabel: UILabel!
    
    @IBOutlet weak var stackViewOfTwoTextfield: UIStackView!
    
    let viewModel = loginViewModels()
    let disposeBag = DisposeBag()
    
    var videoPlayer:AVPlayer!
    var playerItem:AVPlayerItem!
    var location:WLLocation!
    var appDelegate:AppDelegate?
    var isCreated:Bool = false
    
    // #MARK: view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        configureUI()
        
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
    
    func configureUI() {
        textfieldUserName.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: usernameHintLabel.rx.validateResult)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: textfieldPasswd.rx.inputEnabled)
            .disposed(by: disposeBag)
        
        
        // viewModels 里 的 password 监听 输入框的 输入事件
        textfieldPasswd.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // 鉴定 view modle 的 按钮是否可用
        viewModel.loginButtonUsable
            .subscribe(onNext: { [unowned self] valid in
                self.btLogin.isEnabled = valid
                self.btLogin.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        // 按钮事件流
        btLogin.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
        
        viewModel.loginResult
            .subscribe(onNext: {[unowned self]  result in
                switch result {
                case .Ok:
                    self.loginSuccToNext()
                case .Empty:
                    self.showAlertView(title: "提示", message: "")
                case let .Failed(message):
                    self.loginFailAnimate()
//                    self.showOneButtonDialog(title: "提示", description: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // #MARK: 动画
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
        
        self.perform(#selector(self.afterImageViewAnimateFinished), with: nil, afterDelay: 3.0)
        
        //过渡动画
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 1.0
            self.videoPlayer.play()
        }, completion: nil)
    }
    
    @objc func afterImageViewAnimateFinished() {
     
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundImageView.alpha = 0
            self.stackViewOfTwoTextfield.alpha = 1
        }) { (complete) in
//            self.backgroundImageView.removeFromSuperview()
        }
    }
    
    //初始化视频层
    func initGuideVideoPlayer() {
        let videoPath = Bundle.main.path(forResource: "welcome_video", ofType: "mp4")
        playerItem  = AVPlayerItem(url: URL(fileURLWithPath: videoPath!))
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.frame = self.backView.bounds
        videoPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        
        self.backView.layer.insertSublayer(videoPlayerLayer, at: 0) //插在最根部
        self.backView.alpha = 0.0 //初始情况，backview不可见，当启动动画结束，则可以显示并播放视频
        
        
        //swift 3.0 的 selector写法真是!!!  监控播放结束事件
        NotificationCenter.default.addObserver(self, selector: #selector(self.videoPlayDidEnd(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    @objc func videoPlayDidEnd(sender: Notification) {
        let item = sender.object as! AVPlayerItem
        item.seek(to: kCMTimeZero)
        self.videoPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    // #MARK: action
    @IBAction func btRegisterPressed(_ sender: Any) {

        
        let userInfoVC = WLUserInfoViewController()
        let nav = UINavigationController(rootViewController: userInfoVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    func loginFailAnimate() {
        shakeAnimation(with: btLogin)
    }
    
    func loginSuccToNext() {

//        appDelegate?.showHomePage()
        
        //登录按钮的动画，按钮扩展全面视图
        btLogin.animate(0.6) { [unowned self] in
            self.stackViewOfTwoTextfield.alpha = 0
            self.backgroundImageView.alpha = 1
            
//            let homePage = WLHomePageViewController()
//            let nav = UINavigationController(rootViewController: homePage)
//            nav.transitioningDelegate = self
//            self.present(nav, animated: true, completion: nil)
            
            let mainViewController   = WLHomePageViewController()
            let drawerViewController = DrawerViewController()
            let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: ScreenWidth*270/320)
            drawerController.mainViewController = UINavigationController(
                rootViewController: mainViewController
            )
            
            drawerController.drawerViewController = drawerViewController
            self.present(drawerController, animated: true, completion: nil)
            self.appDelegate?.globalDrawerController = drawerController
        }
        
    }
    

    // MARK: textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
