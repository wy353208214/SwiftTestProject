//
//  PhtotoDetailController.swift
//  TestProject
//
//  Created by steven on 2021/7/29.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import SDWebImage
import Zoomy
import Toast_Swift

class PhtotoDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var items = Array<PhotoItem>.init()
    //第一次进入默认选中的Item
    var select = 0
    
    //当前显示中的item的index
//    var displayingItemIndex: Int = 0
    
    private let ID = "PhotoDetail"
    private var collectionView: UICollectionView?
    private var titleLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //图片列表CollectionView
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: self.view.bounds.size.width, height: view.bounds.size.height)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView?.register(PhotoDetailCell.classForCoder(), forCellWithReuseIdentifier: ID)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.contentInsetAdjustmentBehavior = UICollectionView.ContentInsetAdjustmentBehavior.never
        collectionView?.backgroundColor = UIColor.black
        
        
        //顶部Title
        let titleBox = UIView()
        titleBox.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.text = items[select].title
        titleBox.addSubview(titleLabel)
        
        
        //底部下载的Button
        let downloadBtn = UIButton()
        downloadBtn.layer.masksToBounds = true
        downloadBtn.layer.cornerRadius = 10.0
        downloadBtn.layer.borderWidth = 1.0
        downloadBtn.layer.borderColor = UIColor.lightGray.cgColor
        downloadBtn.setTitle("下载", for: UIControl.State.normal)
        downloadBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        downloadBtn.backgroundColor = UIColor.white
        //下载点击事件
        downloadBtn.addTarget(self, action: #selector(self.download), for: UIControl.Event.touchUpInside)
        
        //添加view
        self.view.addSubview(collectionView!)
        self.view.addSubview(downloadBtn)
        self.view.addSubview(titleBox)
        
        
        //设置Button布局约束
        downloadBtn.snp.makeConstraints{(make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        titleBox.snp.makeConstraints{(make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        titleLabel.snp.makeConstraints{(make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        collectionView?.scrollToItem(at: IndexPath(item: select, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        collectionView?.isPagingEnabled = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let position = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! PhotoDetailCell
        cell.image.contentMode = UIView.ContentMode.scaleAspectFit
        cell.image.sd_setImage(with: URL(string: items[position].url))
        
        //添加点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.back))
        tap.numberOfTapsRequired = 1
        cell.image.isUserInteractionEnabled = true
        cell.image.addGestureRecognizer(tap)
        
        //添加图片缩放
        addZoombehavior(for: cell.image)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let indexPaths = collectionView.indexPathsForVisibleItems
        if !indexPaths.isEmpty {
            let index = indexPaths[0].row
            titleLabel.text = items[index].title
        }
    }
    
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

    
    @objc func download() {
        let indexPaths = collectionView!.indexPathsForVisibleItems
        if !indexPaths.isEmpty {
            let index = indexPaths[0].row
            let item: PhotoItem = items[index]
            let url = item.url
            print(item.title)
            let sdImageCache = SDImageCache()
            sdImageCache.diskImageExists(withKey: url, completion: {(isCache: Bool) -> Void in
                if isCache {
                    let data = sdImageCache.diskImageData(forKey: url)
                    let img = UIImage.init(data: data!)
                    UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.saveError), nil)
                }
            })
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            self.view.makeToast("保存成功", duration: 1.5)
        }else {
            self.view.makeToast("保存失败", duration: 1.5)
        }
    }
    
    
    class PhotoDetailCell: UICollectionViewCell {
        
        var image:UIImageView = UIImageView.init()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.contentView.addSubview(image)
            
            image.snp.makeConstraints{ (make) -> Void in
                make.center.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init() has error")
        }
        
        
    }

}
