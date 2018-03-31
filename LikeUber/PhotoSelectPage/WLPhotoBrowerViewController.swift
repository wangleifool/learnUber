//
//  WLPhtoBrowerViewController.swift
//  LikeUber
//
//  Created by lei wang on 2018/3/31.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit


class WLPhotoBrowerViewController: UIViewController,UIViewControllerTransitioningDelegate {

    lazy var photoView: WLPhotoView = {
        let view: WLPhotoView = WLPhotoView(frame: self.view.bounds)
        return view;
    }()
    
    var items: Array<WLPhotoItem>
    
    lazy var btDone: UIButton = {
        var frame = CGRect(x: 0, y: 8, width: 64, height: 64)
        frame.x = self.view.bounds.width - frame.width - 8
        let bt = UIButton(frame: frame)
        bt.addTarget(self, action: #selector(self.btDonePressed(sender:)), for: .touchUpInside)
        bt.setTitle("完成", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        
        return bt
    }()
    
    
    
    init(items: Array<WLPhotoItem>, selectedIndex: UInt) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle   = .coverVertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        
        // Do any additional setup after loading the view.
        configureSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureBackground() {
        self.view.backgroundColor = UIColor.black
    }

    func configureSubviews() {
        self.view.addSubview(self.photoView)
        self.photoView.setItem(item: items[0])
        
        self.view.addSubview(self.btDone)
    }
    
    // MARK: private method
    @objc func btDonePressed(sender: UIButton?) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func addGesture() {
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)
    }
    
    
    // MARK: gesture deal
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        if photoView.zoomScale == 1.0 {
            let location = gesture.location(in: self.view)
            
        } else {
            photoView.zoomScale = 1.0
        }
    }
}
