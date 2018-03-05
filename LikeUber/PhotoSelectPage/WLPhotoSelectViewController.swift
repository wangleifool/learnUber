//
//  WLPhotoSelectViewController.swift
//  LikeUber
//
//  Created by lei wang on 2018/1/23.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit
import SnapKit
import Photos

let numPhotoPerLine:CGFloat = 4.0
let heightAllAlbumsTableView = 400.0
let heightForAlbumTableViewCellImage:CGFloat = 44.0
let heightForAlbumTableViewCell:CGFloat      = 64.0

let showAllAlbumTitle = "轻触更改相册 "
let hideAllAlbumTitle = "轻触这里收起 "

let imageCollectionReusableIdentifier = "PhotoSelectCell"

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class WLPhotoSelectViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    // 媒体库
    var allAvailableAlbums: PHFetchResult<PHAssetCollection>!
    var allAvailableAlbumsArray: NSMutableArray! = NSMutableArray()
    var allAlbumsPhotoAssets: NSMutableArray! = NSMutableArray()
    var avaliableSmartAlbum = ["相机胶卷","全景照片","个人收藏","最近添加","屏幕截图"]//["Camera Roll","Panoramas","Favorite","Recently Added","Screenshots"]
    var assetManager = PHCachingImageManager()
    var currentAlbumIndex: Int = 0  // 默认相册为0
    
    var currentAlbumPhotoAsset: PHFetchResult<PHAsset>?
    
    lazy var allAlbumsTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0) //默认隐藏
        })
        return tableView
    }()
    
    var backgroundCancelButton: UIButton?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var showAlbumsHintLabel: UILabel!
    @IBOutlet weak var btTitle: UIButton!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionLayout: UICollectionViewFlowLayout!
    
    var thumbnailSize:CGSize!
    var previousPreheatRect = CGRect.zero
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCachedAssets()
        
        self.view.layer.cornerRadius = 8.0
        self.view.backgroundColor = UIColor.brown
        // Do any additional setup after loading the view.
        
        getAllAvailableAlbumData()
        
        configureCollectionView()
//        configureHeaderView()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        configureHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCachedAssets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setShowAlbumsHintLabel(isShowed: Bool) {
        var attributeString = NSMutableAttributedString()
        let hintAttibuteString = NSAttributedString(string: (isShowed ? hideAllAlbumTitle : showAllAlbumTitle))
        attributeString.append(hintAttibuteString)
        
        let text = NSTextAttachment()
        if let image = UIImage(named:(isShowed ? "up" : "down")) {
            text.image = image
            text.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let attachmentAT = NSAttributedString(attachment: text)
            attributeString.append(attachmentAT)
        }
        
        showAlbumsHintLabel.attributedText = attributeString
    }
    

    
    func configureHeaderView() {
        let albumCollection = allAvailableAlbumsArray.object(at: currentAlbumIndex) as! PHAssetCollection
        self.btTitle.setTitle(albumCollection.localizedTitle, for: .normal)
        setShowAlbumsHintLabel(isShowed: false)
        hideAllAlbumTableView()
    }
    
    func configureCollectionView() {
        let cellWidth = (self.photoCollectionView.bounds.size.width - (numPhotoPerLine-1)*2) / numPhotoPerLine 
        photoCollectionLayout.itemSize = CGSize.init(width: cellWidth, height: cellWidth)
        photoCollectionLayout.minimumLineSpacing = 2
        photoCollectionLayout.minimumInteritemSpacing = 2
        photoCollectionLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: cellWidth*scale, height: cellWidth*scale)
        
        photoCollectionView.register(UINib.init(nibName: "WLPhotoSelectCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: imageCollectionReusableIdentifier)
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
        return currentAlbumPhotoAsset!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = currentAlbumPhotoAsset?.object(at: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionReusableIdentifier, for: indexPath) as! WLPhotoSelectCollectionViewCell
        
                
        // 获取照片
        cell.representedIdentifier = asset?.localIdentifier
        let requestOption = PHImageRequestOptions()
        requestOption.resizeMode = .exact
        var rect = CGRect.zero
        rect.size = photoCollectionLayout.itemSize
        requestOption.normalizedCropRect = rect
        
        assetManager.requestImage(for: asset!, targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOption) { (image, _) in
            if cell.representedIdentifier == asset?.localIdentifier && image != nil {
                cell.imageButton.setBackgroundImage(image, for: .normal)
            }
        }
        
        return cell
    }
    
    
    // MARK: collecion layout 布局
    
    // MARK: 所有相册的列表相关
    func addBackgroundCancelButton() {
        backgroundCancelButton = UIButton(frame: self.view.bounds)
        backgroundCancelButton!.backgroundColor = UIColor.black
        backgroundCancelButton!.alpha = 0
        backgroundCancelButton!.addTarget(self, action: #selector(self.backgroundCancelButtonClick), for: .touchUpInside)
        self.view.addSubview(backgroundCancelButton!)
        
        self.view.bringSubview(toFront: self.allAlbumsTableView)
        self.view.bringSubview(toFront: self.headerView)
    }
    
    @objc func backgroundCancelButtonClick() {
        hideAllAlbumTableView()
    }
    
    func showAllAlbumTableView() {
        setShowAlbumsHintLabel(isShowed: true)
        
        addBackgroundCancelButton()
        
        
        UIView.animate(withDuration: 0.2) {
            
            self.allAlbumsTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.headerView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(heightAllAlbumsTableView) //默认隐藏
            }
            
            self.backgroundCancelButton?.alpha = 0.5
            
            //用来立即刷新布局（不写无法实现动画移动，会变成瞬间移动）
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func hideAllAlbumTableView() {
        setShowAlbumsHintLabel(isShowed: false)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.allAlbumsTableView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.headerView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(0) //默认隐藏
            }
            
            self.backgroundCancelButton?.alpha = 0
            
            self.view.layoutIfNeeded()
        }) { (isComplete) in
            self.backgroundCancelButton?.removeFromSuperview()
        }
        
    }
    
    @IBAction func btChangeAlbumClick(_ sender: Any) {
        if let bt = sender as? UIButton {
            if bt.tag == 0 {
                bt.tag = 1
                showAllAlbumTableView()
            } else {
                bt.tag = 0
                hideAllAlbumTableView()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAvailableAlbumsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "albumsCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "albumsCell")
        }
        
        let assetCollection: PHAssetCollection = allAvailableAlbumsArray.object(at: indexPath.row) as! PHAssetCollection
        let allAssetsInCollection: PHFetchResult<PHAsset> = allAlbumsPhotoAssets.object(at: indexPath.row) as! PHFetchResult
        
        cell!.textLabel?.text = assetCollection.localizedTitle
        cell!.detailTextLabel!.text = String(allAssetsInCollection.count)
        cell!.accessoryType = (currentAlbumIndex == indexPath.row) ? .checkmark : .none
        
        
        let asset = allAssetsInCollection.object(at: 0) //取第一张图片作为预览图
        assetManager.requestImage(for: asset, targetSize: CGSize(width: 44.0,height:44.0), contentMode: .aspectFill, options: nil) { (image, _) in
            if image != nil {
                
                cell?.imageView?.image = image
                
                // 修改cell imageview的尺寸
                let itemSize = CGSize(width: heightForAlbumTableViewCellImage, height: heightForAlbumTableViewCellImage)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                let imageRect = CGRect(x:0 ,y:0 ,width:itemSize.width ,height:itemSize.height)
                cell?.imageView?.image?.draw(in: imageRect)
                
                cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForAlbumTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath)
        for visiableCell in tableView.visibleCells {
            visiableCell.accessoryType = .none
        }
        cell?.accessoryType = .checkmark
        
        currentAlbumIndex = indexPath.row
        currentAlbumPhotoAsset = allAlbumsPhotoAssets.object(at: currentAlbumIndex) as? PHFetchResult<PHAsset>
        
        btTitle.setTitle(cell?.textLabel?.text, for: .normal)
        photoCollectionView.reloadData()  //刷新照片列表
        hideAllAlbumTableView()
    }
    
    // MARK: all albums data
    func saveDataToTempory(_ assetCollection: PHAssetCollection) {
        // 获取相册集里所有的资源
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let allAssetsInAlbum = PHAsset.fetchAssets(in: assetCollection, options: option)
        
        if allAssetsInAlbum.count == 0 {
            return
        }
        
        
        
        // 筛选过后的相册对象保存
        if assetCollection.localizedTitle == "相机胶卷" {
            allAvailableAlbumsArray.insert(assetCollection, at: 0)  //相机胶卷插入顶端
            // 每个相册的所以资源对象 保存到数组
            allAlbumsPhotoAssets.insert(allAssetsInAlbum, at: 0)
        } else {
            allAvailableAlbumsArray.add(assetCollection)
            // 每个相册的所以资源对象 保存到数组
            allAlbumsPhotoAssets.add(allAssetsInAlbum)
        }
        
        
        
    }
    
    func getAllAvailableAlbumData() {
//        let albumOption = PHFetchOptions()
//        albumOption.predicate = NSPredicate(format: "title = %@", "Camera Roll")  //NSPredicate(format: "title = %@", argumentArray: ["Camera Roll"])
        
        // 先获取智能相册
        allAvailableAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        for i in 0 ..< allAvailableAlbums.count {
            // 获取相册集
            let assetCollection = allAvailableAlbums.object(at: i)
        
            
            if !avaliableSmartAlbum.contains(assetCollection.localizedTitle!) {
                continue
            }
            
            
            
            // 保存数据到内存
            saveDataToTempory(assetCollection)
            
        }
        
        // 再获取用户创建的相册
        allAvailableAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        for i in 0 ..< allAvailableAlbums.count {
            let assetCollection = allAvailableAlbums.object(at: i)
            
            saveDataToTempory(assetCollection)
        }
        
        // 一些初始化
        currentAlbumPhotoAsset = allAlbumsPhotoAssets.object(at: currentAlbumIndex) as? PHFetchResult<PHAsset>
        
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        assetManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    // 有了这个函数，缓存出来的图片尺寸才会正确
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: photoCollectionView!.contentOffset, size: photoCollectionView!.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in photoCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in currentAlbumPhotoAsset!.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in photoCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in currentAlbumPhotoAsset!.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        assetManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        assetManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}
