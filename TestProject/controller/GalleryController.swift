//
//  GalleryController.swift
//  TestProject
//
//  Created by yang on 2021/8/2.
//  Copyright © 2021 hackyang. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class GalleryController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let CELL_ID = "Image Cell";
    private var datas = Array<PhotoItem>.init()
    private let tableView = UITableView()
    private let headImage = UIImageView()
    private var currentPage = 1
    
    private var footer:MJRefreshBackGifFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //显示navigationbar
        navigationController?.setNavigationBarHidden(false, animated:false)
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemPurple
        headerView.frame.size.height = self.view.frame.width * 4 / 7
        headImage.clipsToBounds = true
        
        headImage.contentMode = UIView.ContentMode.scaleAspectFill
        headerView.addSubview(headImage)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageCell.classForCoder(), forCellReuseIdentifier: CELL_ID)
        tableView.tableFooterView = UIView.init()
        tableView.tableHeaderView = headerView
        self.view.addSubview(tableView)
        
        
        //添加header刷新
        MJRefreshNormalHeader {[weak self] in
            self?.getPhotoList(page: 1, isRefesh: true)
        }.autoChangeTransparency(true)
        .link(to: tableView)
        tableView.mj_header?.beginRefreshing()
        
        
        //添加Footer刷新
        var images = Array<UIImage>()
        images.append(UIImage.init(named: "dropdown_loading_01")!)
        images.append(UIImage.init(named: "dropdown_loading_02")!)
        images.append(UIImage.init(named: "dropdown_loading_03")!)
        
        var idleImages = Array<UIImage>()
        idleImages.append(UIImage.init(named: "dropdown_loading_01")!)
        
        var pullImages = Array<UIImage>()
        pullImages.append(UIImage.init(named: "dropdown_loading_03")!)
        
        footer = MJRefreshBackGifFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadMore))
        footer!.setImages(images,for: MJRefreshState.refreshing)
        footer!.setImages(pullImages,for: MJRefreshState.pulling)
        footer!.setImages(idleImages,for: MJRefreshState.idle)
        
        
        tableView.snp.makeConstraints{(make)-> Void in
            make.edges.equalToSuperview()
        }
        
        headImage.snp.makeConstraints{(make) -> Void in
            make.size.equalToSuperview()
        }
        
        //先从缓存读取数据
        let items = getCacheDatas()
        for item in items {
            let data = item as! NSDictionary
            let title = data["setname"] as! String
            let url = data["cover"] as! String
            self.datas.append(PhotoItem(url: url, title: title))
        }
        if !datas.isEmpty {
            headImage.sd_setImage(with: URL(string:datas[Int.random(in: 0..<datas.count)].url))
        }
        self.tableView.reloadData()

    }
    
    
    @objc func loadMore() {
        getPhotoList(page: currentPage + 1, isRefesh: false)
    }
    
    @objc func onRefreshComplete() {
        //更新头部
        headImage.sd_setImage(with:  URL(string:datas[Int.random(in: 0..<datas.count)].url))
        tableView.reloadData()
        
        //第一次刷新完毕之后再添加footer
        if tableView.mj_footer == nil {
            tableView.mj_footer = footer!
        }
    }
    
    @objc func onLoadMoreComplete() {
        tableView.reloadData()
    }
    
    
    private func getPhotoList(page: Int, isRefesh: Bool) {
        print("page is：", page)
        AF.request("https://api.isoyu.com/api/picture/index", parameters: ["page": page]) {urlRequest in
            urlRequest.timeoutInterval = 10
        }.responseJSON { response in
            if let json = response.value {
                let dict = json as? NSDictionary
                if dict != nil {
                    let items = dict?["data"] as! NSArray
                    
                    //更新页码
                    if isRefesh {
                        self.currentPage = 1
                        self.datas.removeAll()
                        //保存到缓存
                        self.saveToCache(data: items)
                    }else {
                        self.currentPage += 1
                    }
                    
                    for item in items {
                        let data = item as! NSDictionary
                        let title = data["setname"] as! String
                        let url = data["cover"] as! String
                        self.datas.append(PhotoItem(url: url, title: title))
                    }
                }
            }else {
                print(response.error!)
            }
            if isRefesh {
                self.tableView.mj_header?.endRefreshing(completionBlock: self.onRefreshComplete)
            } else {
                self.tableView.mj_footer?.endRefreshing(completionBlock: self.onLoadMoreComplete)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? ImageCell
        if cell == nil {
            cell = ImageCell.init()
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        let item = datas[indexPath.row]
        
        cell?.title.text = item.title
        
        cell?.photo.sd_setImage(with: URL(string:item.url))
        cell?.photo.tag = indexPath.row
        cell?.photo.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(tab:)))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        cell?.photo.addGestureRecognizer(tap)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    @objc func itemClick(tab: UIGestureRecognizer) {
        let position = tab.view?.tag
        let photoController = PhtotoDetailController()
        photoController.items = datas
        photoController.select = position! as Int
        self.navigationController?.pushViewController(photoController, animated:true)
    }
    
    //保存数据列表到本地plist中
    private func saveToCache(data: NSArray) {
        if data.count == 0 {
            return
        }
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = path?.appendingPathComponent("data.plist")
        data.write(toFile: fileName!.path, atomically: true)
    }
    
    //从缓存读取数
    private func getCacheDatas() -> NSArray {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = path?.appendingPathComponent("data.plist")
        if !FileManager.default.fileExists(atPath: fileName!.path) {
            return NSArray()
        }
        let result = NSArray(contentsOfFile: fileName!.path)
        return result!
    }
    
    
    class ImageCell: UITableViewCell {
        
        var photo = UIImageView();
        var title = UILabel();
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            backgroundColor = UIColor.white
            title.numberOfLines = 2
            title.lineBreakMode = NSLineBreakMode.byTruncatingTail
            title.font = UIFont.systemFont(ofSize: 18)
            title.textColor = UIColor.black
            
            photo.contentMode = UIView.ContentMode.scaleAspectFit
        
            
            contentView.addSubview(title)
            contentView.addSubview(photo)
            
            photo.snp.makeConstraints{(make) -> Void in
                make.width.height.equalTo(80)
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
            }
            title.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(photo.snp.right).offset(20)
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            }

        }

        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            fatalError("init(coder:) has not been implemented")
        }
    }

}
