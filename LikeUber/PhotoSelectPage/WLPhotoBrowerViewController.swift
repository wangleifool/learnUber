//
//  WLPhtoBrowerViewController.swift
//  LikeUber
//
//  Created by lei wang on 2018/3/31.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

let wlAnimationTimeInterval = 0.3

let PhotoNotSelectImageString = "photoNotSelect"
let PhotoSelectImageString = "photoSelect"

class WLPhotoBrowerViewController: UIViewController,UIViewControllerTransitioningDelegate,UIScrollViewDelegate {
    
    
    var items: Array<WLPhotoItem>
    var visiablePhotoViews = Array<WLPhotoView>()
    var currentPhotoIndex: Int = 0
    var allPhotosNumInTrue: Int = 0 //有时候，photobrower不会显示父级视图所有的照片，这里是记录父级视图所有图片数量的
    var selectedPhotosIndex: Array = Array<Int>()
    var photosIndex: Array = Array<Int>() //在可见照片数量和总数量不一致时，单独记录可见照片的index
    
    lazy var mainScrollView: UIScrollView = {
        let frame = self.view.bounds
        let scroll = UIScrollView(frame: frame)
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()
    
    lazy var btDone: UIButton = {
        var frame = CGRect(x: 0, y: 8, width: 64, height: 64)
        frame.x = self.view.bounds.width - frame.width
        let bt = UIButton(frame: frame)
        bt.addTarget(self, action: #selector(self.btDonePressed(sender:)), for: .touchUpInside)
        bt.setTitle("完成", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        
        return bt
    }()
    
    lazy var selectedNumImageView: UIImageView = {
        var frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        frame.x   = self.view.bounds.width - frame.width - btDone.bounds.width + 4
        frame.y   = btDone.bounds.height/2 - frame.size.height/2
        let imageView = UIImageView(frame: frame)
        return imageView
    }()
    
    private lazy var btSelect: UIButton = {
        var frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        frame.y = self.view.bounds.height - frame.height
        frame.x = self.view.bounds.width - frame.width
        let bt = UIButton(frame: frame)
        bt.setImage(UIImage(named: PhotoNotSelectImageString), for: .normal)
        bt.addTarget(self, action: #selector(self.btSelectPressed(sender:)), for: .touchUpInside)
        
        return bt
    }()
    
    private lazy var pageLabel: UILabel = {
        var frame = CGRect(x: 0, y: self.view.bounds.height-40, width: self.view.bounds.width, height: 20)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    init(items: Array<WLPhotoItem>, selectedIndex: Int) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle   = .coverVertical
        
        currentPhotoIndex = selectedIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") 
    }
    
    deinit {
        removeGesture()
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        
        // Do any additional setup after loading the view.
        configureSubviews()
        
        
        addGesture()
        
        
        scrollViewDidScroll(self.mainScrollView)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置imageView 过渡动画效果
        let photoItem = items[currentPhotoIndex]
        if let photoView = getPhotoView(index: currentPhotoIndex) {
            photoView.imageView.image = photoItem.thumbImage
            photoView.resizeImageView()
            
            let endRect = photoView.imageView.frame
            var sourceRect: CGRect?
            if let sourceView = photoItem.sourceView {
                sourceRect = sourceView.superview?.convert(sourceView.frame, to: photoView)  // 获取souceView相对于PhotoView的坐标尺寸
            }
            
            if let rect = sourceRect {
                photoView.imageView.frame = rect   // 设置动画前，imageview的frame如sourceView一样，动画过程让他的frame变成应该有的尺寸
                
                UIView.animate(withDuration: wlAnimationTimeInterval, animations: {
                    photoView.imageView.frame = endRect
                }) { (completion: Bool) in
                    
                }
            }
        }
        
        updateSubviewsUI()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureBackground() {
        self.view.backgroundColor = UIColor.black
    }

    func configureSubviews() {
        self.view.addSubview(self.mainScrollView)
        
        // 根据照片数量，计算scrollview的contentSize和当前图片的位置
        var contentSize = self.mainScrollView.contentSize
        contentSize.width = self.mainScrollView.frame.width * CGFloat(items.count)
        self.mainScrollView.contentSize = contentSize
        self.mainScrollView.contentOffset = CGPoint(x: self.mainScrollView.frame.width*CGFloat(currentPhotoIndex), y: 0)
        
        
        self.view.addSubview(self.btDone)
        self.view.addSubview(self.btSelect)
        self.view.addSubview(self.selectedNumImageView)
        
        self.view.addSubview(self.pageLabel)
        updatePageLabel(page: currentPhotoIndex)
    }
    
    // MARK: private method
    @objc private func btDonePressed(sender: UIButton?) {
        showDismissAnimation()
    }
    
    
    @objc private func btSelectPressed(sender: UIButton?) {
        var currentPage = currentPhotoIndex
        if allPhotosNumInTrue != items.count {
           currentPage = photosIndex[currentPage]
        }
        
        if btSelect.isSelected {
            btSelect.isSelected = false
            btSelect.setImage(UIImage(named: PhotoNotSelectImageString), for: .normal)
            selectedPhotosIndex.remove(object: currentPage)
        } else {
            btSelect.isSelected = true
            btSelect.setImage(UIImage(named: PhotoSelectImageString), for: .normal)
            selectedPhotosIndex.append(currentPage)
        }
        
        updateSelectedNumImageView(animate: true)
    }
    
    private func updateSelectButtonUI() {
        var currentPage = currentPhotoIndex
        if allPhotosNumInTrue != items.count {
            currentPage = photosIndex[currentPhotoIndex]  //photosIndex 存储的是 非全部的图片的，可被查看的图片的index，无序
        }
        
        if selectedPhotosIndex.contains(currentPage) {
            btSelect.isSelected = true
            btSelect.setImage(UIImage(named: PhotoSelectImageString), for: .normal)
        } else {
            btSelect.isSelected = false
            btSelect.setImage(UIImage(named: PhotoNotSelectImageString), for: .normal)
        }
    }
    
    private func updateSelectedNumImageView(animate: Bool) {
        let numSelected = selectedPhotosIndex.count
        
        if numSelected == 0 {
            selectedNumImageView.image = nil
        } else if (numSelected > maxSelectPhotoNum) {
            
        } else {
            let imageName = String(format: "num%lu", arguments: [numSelected])
            selectedNumImageView.image = UIImage(named: imageName)
            
            // 使用key frame，让设置image具有弹性效果
            if animate {
                UIView.animateKeyframes(withDuration: wlAnimationTimeInterval, delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
                    
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/4.0, animations: {
                        self.selectedNumImageView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 1/4.0, relativeDuration: 1/4.0, animations: {
                        self.selectedNumImageView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 2/4.0, relativeDuration: 1/4.0, animations: {
                        self.selectedNumImageView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 3/4.0, relativeDuration: 1/4.0, animations: {
                        self.selectedNumImageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    })
                    
                }, completion: nil)
            }
        }
    }
    
    private func showDismissAnimation() {
        let item = items[currentPhotoIndex]
        let photoView = getPhotoView(index: currentPhotoIndex)
        
        if item.sourceView == nil {  // 没有记录sourceView
            UIView.animate(withDuration: wlAnimationTimeInterval, animations: {
                self.view.alpha = 0
            }) { (completion) in
                if completion {
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
            return
        }
        
        var sourceRect: CGRect?
        if let sourceView = item.sourceView {
            sourceRect = sourceView.superview?.convert(sourceView.frame, to: photoView)  // 获取souceView相对于PhotoView的坐标尺寸
        }
        
        if let rect = sourceRect {
            UIView.animate(withDuration: wlAnimationTimeInterval, animations: {
                photoView?.imageView.frame = rect
                self.view.backgroundColor = UIColor.clear
            }) { (completion) in
                if completion {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
        
    }
    
    private func updatePageLabel(page: Int) {
        self.pageLabel.text = String(currentPhotoIndex+1) + "/" + String(items.count)
    }
    
   
    
    // MARK: gesture deal
    private func addGesture() {
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTapGesture)
    }
    
    private func removeGesture() {
        if let gestures = self.view.gestureRecognizers {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        let photoView = getPhotoView(index: currentPhotoIndex)
        if photoView?.zoomScale == 1.0 {
            let location = gesture.location(in: self.view)
            let maxZoomScale = photoView?.maximumZoomScale;
            let width = self.view.bounds.size.width / maxZoomScale!;
            let height = self.view.bounds.size.height / maxZoomScale!;
            
            photoView?.zoom(to: CGRect(x: location.x - width/2, y: location.y - height/2, width: width, height: height), animated: true)
            
        } else {
            photoView?.setZoomScale(1.0, animated: true)
        }
    }
    
    
    private func getPhotoView(index: Int) -> WLPhotoView? {
        for photoView in self.visiablePhotoViews {
            if photoView.tag == index {
                return photoView
            }
        }
        
        return nil
    }
    
    private func updateSubviewsUI() {
        updatePageLabel(page: currentPhotoIndex)
        updateSelectedNumImageView(animate: false)
        updateSelectButtonUI()
    }
    
    // MARK: scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {        
        configurePhotoViews()
        removeUnvisiablePhotoViews()
    }
    
    // 移除暂时不在 三视图 循环 的PhotoView，提高性能
    private func removeUnvisiablePhotoViews() {
        if let currentPageFrame = getPhotoView(index: currentPhotoIndex)?.frame {
            var removeArray = Array<WLPhotoView>()
            for photoView in visiablePhotoViews {
                if (photoView.frame.x < currentPageFrame.x - currentPageFrame.width ||
                    photoView.frame.x > currentPageFrame.x + 2*currentPageFrame.width) {
                    
                    removeArray.append(photoView)
                    photoView.removeFromSuperview()
                }
            }
            
            
            visiablePhotoViews.removeFrom(array: removeArray)            
            
        }
    }
    
    // 刷新需要显示的photoView
    private func configurePhotoViews() {
        let scrollView = self.mainScrollView
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        // 使用经典的 三页面 循环重用
        for i in page-1 ... page+1 {
            if (i < 0 || i >= items.count) {
                continue
            }
            
            var photoView = getPhotoView(index: i)
            if photoView == nil {
                
                var frame = scrollView.frame
                frame.x = CGFloat(i) * scrollView.frame.width // 计算photoview应该在位置
                photoView = WLPhotoView(frame: frame)
                photoView?.tag = i
                
                scrollView.addSubview(photoView!)
                visiablePhotoViews.append(photoView!)
            }
            
            if photoView?.photoItem == nil {
                photoView?.setItem(item: items[i])
            }
            
        }
        
        if page != currentPhotoIndex {
            currentPhotoIndex = page
            updateSubviewsUI()
        }
    }
    
    
    
}
