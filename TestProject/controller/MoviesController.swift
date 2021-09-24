//
//  MoviesController.swift
//  TestProject
//
//  Created by steven on 2021/9/17.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class MoviesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let MOVIE_CELL = "Movie Cell"
    
    private var datas = Array<MovieModel>.init()
    private var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let itemWidth = self.view.frame.width/2 - 6
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        //添加header刷新
        MJRefreshNormalHeader {[weak self] in
            self?.getMovies()
        }.autoChangeTransparency(true)
        .link(to: collectionView)
        collectionView.mj_header?.beginRefreshing()
        
        let footer = MjRefreshManager.instance.GifFooter(target: self, action: #selector(self.loadMore))
        collectionView.mj_footer = footer
        
        collectionView.snp.makeConstraints{(make) -> Void in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.classForCoder(), forCellWithReuseIdentifier: MOVIE_CELL)
        collectionView.contentInsetAdjustmentBehavior = UICollectionView.ContentInsetAdjustmentBehavior.never
        collectionView.backgroundColor = UIColor.white
    
    }
    
    
    private func getMovies() {
        AF.request("https://api.isoyu.com/api/Video/video_type?type=2&page=30")
            .responseJSON {response in
                if let json = response.value {
                    let dict = json as? NSDictionary
                    if dict != nil {
                        let items = dict?["data"] as! NSArray
                        for item in items {
                            let data = item as! NSDictionary
                            let cover = data["cover"] as! String
                            let title = data["title"] as! String
                            let topicDesc = data["topicDesc"] as! String
                            let vid = data["vid"] as! String
                            let mp4_url = data["mp4_url"] as! String
                            let m3u8_url = data["m3u8_url"] as! String
                            let length = data["length"] as! Int
                            self.datas.append(MovieModel(cover: cover, title: title, topicDesc: topicDesc, vid: vid, mp4_url: mp4_url, m3u8_url: m3u8_url, length: length))
                        }
                    }
                    self.collectionView.mj_header?.endRefreshing()
                    self.collectionView.reloadData()
                }
            }
    }
    
    @objc func loadMore() {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MOVIE_CELL, for: indexPath) as! MovieCell
        let movie = datas[indexPath.row]
        cell.coverImg.sd_setImage(with: URL.init(string: movie.cover))
        cell.title.text = movie.title
        cell.topicDesc.text = movie.topicDesc
        
        cell.contentView.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(tab:)))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        cell.contentView.addGestureRecognizer(tap)
        return cell
    }
    
    @objc func itemClick(tab: UIGestureRecognizer) {
        let position = (tab.view?.tag)! as Int
        let videoController = VideoPlayerController(movie: datas[position])
        self.navigationController?.pushViewController(videoController, animated: false)
    }
    
    
    class MovieCell: UICollectionViewCell{
    
        let coverImg = UIImageView()
        let title = UILabel()
        let topicDesc = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(coverImg)
            contentView.addSubview(title)
            contentView.addSubview(topicDesc)
//            contentView.backgroundColor = UIColor.systemGray
            
            title.font = UIFont.boldSystemFont(ofSize: 14)
            topicDesc.font = UIFont.systemFont(ofSize: 12)
            topicDesc.textColor = UIColor.darkGray
            
            coverImg.snp.makeConstraints{(make) -> Void in
                make.width.equalToSuperview()
                make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
            }
            title.snp.makeConstraints{(make) -> Void in
                make.top.equalTo(coverImg.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(4)
                make.right.equalToSuperview().offset(-4)
                make.height.equalTo(20)
            }
            topicDesc.snp.makeConstraints{(make) -> Void in
                make.top.equalTo(title.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(4)
                make.right.equalToSuperview().offset(-4)
                make.height.equalTo(20)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
