//
//  WLPhotoSelectVC-AllPhotoCollectionView.swift
//  LikeUber
//
//  Created by lei wang on 2018/3/7.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation
import Photos
import KSPhotoBrowser

extension WLPhotoSelectViewController : UICollectionViewDataSource,UICollectionViewDelegate,WLPhotoSelectCollectionViewCellDelegate {
    
    
    // MARK: collection view data source
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAlbumPhotoAsset!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = currentAlbumPhotoAsset?.object(at: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionReusableIdentifier, for: indexPath) as! WLPhotoSelectCollectionViewCell
        
        if (cell.delegate == nil) {
            cell.delegate = self
        }
        
        // 判断是否可选
        if selectedPhotoIndex.count >= maxSelectPhotoNum {
            
            if selectedPhotoIndex.contains(indexPath.row) {
                cell.isCanSelect = true
            } else {
                cell.isCanSelect = false
            }
            
        } else {
            cell.isCanSelect = true
        }
        
        if selectedPhotoIndex.contains(indexPath.row) {
            cell.isChoosed = true
        } else {
            cell.isChoosed = false
        }
        
        // 获取照片
        cell.representedIdentifier = asset?.localIdentifier
        let requestOption = PHImageRequestOptions()
        requestOption.resizeMode = .exact
        var rect = CGRect.zero
        rect.size = photoCollectionLayout.itemSize
        requestOption.normalizedCropRect = rect
        
        assetManager.requestImage(for: asset!, targetSize: thumbnailSize, contentMode: .aspectFill, options: requestOption) { (image, _) in
            if cell.representedIdentifier == asset?.localIdentifier && image != nil {
                cell.imageView.image = image
                print("indexpath.row: \(indexPath.row)")
                
                //                self.currentAlbumPhotoImages.insert(image!, at: indexPath.row)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: false)
        
        let items = NSMutableArray()
        
        // 已经是最大选择数目
        if selectedPhotoIndex.count >= maxSelectPhotoNum {
            
            if selectedPhotoIndex.contains(indexPath.row) {
                for i in selectedPhotoIndex {
                    let asset: PHAsset = currentAlbumPhotoAsset?.object(at: i as! Int) as! PHAsset
                    
                    let newIndexPath = IndexPath(row: i as! Int, section: 0)
                    let cell = collectionView.cellForItem(at: newIndexPath) as? WLPhotoSelectCollectionViewCell
                    
                    
                    let item: KSPhotoItem = KSPhotoItem(sourceView: cell?.imageView, imageAsset:asset)
                    
                    items.add(item)
                    
                }
            } else {
                return   // 已经选择了最大数，点击非选择图片，不做响应
            }
            
        } else {
            for i in 0 ..< currentAlbumPhotoAsset!.count {
                let asset: PHAsset = currentAlbumPhotoAsset?.object(at: i) as! PHAsset
                
                let newIndexPath = IndexPath(row: i, section: 0)
                let cell = collectionView.cellForItem(at: newIndexPath) as? WLPhotoSelectCollectionViewCell
                let item: KSPhotoItem = KSPhotoItem(sourceView: cell?.imageView, imageAsset:asset)
                
                items.add(item)
                
            }
        }
        
        
        
        let browser: KSPhotoBrowser = KSPhotoBrowser(photoItems: items as! [KSPhotoItem], selectedIndex: UInt(indexPath.row))
        browser.dismissalStyle = .scale
        browser.backgroundStyle = .black
        browser.pageindicatorStyle = .text
        browser.loadingStyle = .determinate
        browser.show(from: self)
        
    }
    
   
    // MARK: collecion layout 布局
    
    
    // MARK: cell selected delegate
    func cellSelectStateChanged(cell: WLPhotoSelectCollectionViewCell) {
        if let selectIndex = photoCollectionView.indexPath(for: cell)?.row {
            if cell.isChoosed {
                selectedPhotoIndex.add(selectIndex)
            } else {
                selectedPhotoIndex.remove(selectIndex)
            }
            
            updateSelectedNumUI() //刷新UI                        
        }
    }
    
}
