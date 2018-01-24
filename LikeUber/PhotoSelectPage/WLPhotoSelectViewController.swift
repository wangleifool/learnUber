//
//  WLPhotoSelectViewController.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/23.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit

let numPhotoPerLine:CGFloat = 4.0

class WLPhotoSelectViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate{
    
    

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 8.0
        self.view.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view.
        
        configureCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCollectionView() {
        let cellWidth = self.photoCollectionView.bounds.size.width / numPhotoPerLine
        photoCollectionLayout.itemSize = CGSize.init(width: cellWidth, height: cellWidth)
        photoCollectionLayout.minimumLineSpacing = 0
        photoCollectionLayout.minimumInteritemSpacing = 0
        photoCollectionLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        photoCollectionView.register(UINib.init(nibName: "WLPhotoSelectCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoSelectCell")
        photoCollectionView.bounces = false
        
    }
    

    @IBAction func btDonePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoSelectCell", for: indexPath)
        return cell
    }
    
    
    // MARK: scroll delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = scrollView.frame.size.height;
        let offsetY = scrollView.contentOffset.y;
        let maxOffset = scrollView.contentSize
        
        
        
        let bottomOffset = maxOffset.height - offsetY; //距离底部位置
        print("collectionView offsetY: \(offsetY) bottomOffset \(bottomOffset)")
        
        
//        // 到达顶部或底部
//        if (offsetY < 0 || bottomOffset <= scrollHeight) {
//            scrollView.isScrollEnabled = false;
//        } else {
//            scrollView.isScrollEnabled = true;
//        }
    }
}
