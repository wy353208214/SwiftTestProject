//
//  ViewController.swift
//  TestProject
//
//  Created by steven on 2021/7/27.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import SnapKit

class ViewController: UIViewController {

    private let WIDTH = CGFloat(360)
    private let button = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        let centerBox = UIView()
        
        //Hello world
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "hello world hello world hello world hello world "
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        //限制最大宽度及行数，超过宽度显示为...省略号
//        label.preferredMaxLayoutWidth = WIDTH - 20
        label.numberOfLines = 1
        //设置圆角
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10.0
         
        //PageController
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.systemGreen
        button.setTitle("CosPlay美女", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        //PhotoListController
        let box = UIView()
        box.layer.cornerRadius = 8
        box.layer.masksToBounds = true
        box.layer.borderWidth = 1
        box.layer.borderColor = UIColor.orange.cgColor
        box.backgroundColor = UIColor.orange
        let child = UILabel()
        child.text = "美女图片"
        child.textAlignment = .center
        child.textColor = UIColor.white
        child.font = UIFont.boldSystemFont(ofSize: 24)
        child.backgroundColor = UIColor.black
        
        //CovidController
        let covindBtn = UIButton()
        covindBtn.layer.masksToBounds = true
        covindBtn.layer.cornerRadius = 10.0
        covindBtn.layer.borderWidth = 1.0
        covindBtn.layer.borderColor = UIColor.lightGray.cgColor
        covindBtn.showsTouchWhenHighlighted = true
        covindBtn.backgroundColor = UIColor.systemTeal
        covindBtn.setTitle("新冠实时统计", for: UIControl.State.normal)
        covindBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        covindBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        //地区列表
        let areaBtn = UIButton()
        areaBtn.layer.masksToBounds = true
        areaBtn.layer.cornerRadius = 10.0
        areaBtn.layer.borderWidth = 1.0
        areaBtn.layer.borderColor = UIColor.lightGray.cgColor
        areaBtn.showsTouchWhenHighlighted = true

        areaBtn.backgroundColor = UIColor.systemYellow
        areaBtn.setTitle("地区选择", for: UIControl.State.normal)
        areaBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        areaBtn.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        
        box.addSubview(child)
        centerBox.addSubview(box)
        centerBox.addSubview(label)
        centerBox.addSubview(button)
        centerBox.addSubview(covindBtn)
        centerBox.addSubview(areaBtn)
        self.view.addSubview(centerBox)
        
        centerBox.snp.makeConstraints{(make) -> Void in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(label.snp.top)
            make.bottom.equalTo(areaBtn.snp.bottom)
        }
    
        //Hello World
        label.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(60)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }

        //Page
        button.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(label.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        //PhotoList
        child.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        box.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(child.snp.bottom).offset(10)
        }
        
        //Covid Controller
        covindBtn.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(box.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        //Area Controller
        areaBtn.snp.makeConstraints{ (make) -> Void in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(covindBtn.snp.bottom).offset(20)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(self.onClick), for: UIControl.Event.touchUpInside)
        covindBtn.addTarget(self, action: #selector(self.goCovidController), for: UIControl.Event.touchUpInside)
        areaBtn.addTarget(self, action: #selector(self.goAreas), for: UIControl.Event.touchUpInside)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.goGallery))
        tap.numberOfTapsRequired = 1
        box.isUserInteractionEnabled = true
        box.addGestureRecognizer(tap)
    
//        let contenView = ContentView()
        // Do any additional setup after loading the view.
    }
    
    @objc func onClick(){
        self.navigationController?.pushViewController(PageViewController(), animated:true)
        //模态跳转Modal
//        present(PhtotoDetailController(), animated: true)
    }
    
    @objc func goCovidController(){
        self.navigationController?.pushViewController(CovidListController(), animated:true)
    }
    
    @objc func goGallery() {
        self.navigationController?.pushViewController(GalleryController(), animated:false)
    }
    
    @objc func goAreas() {
//        self.navigationController?.pushViewController(MoviesController(), animated:false)
        self.navigationController?.pushViewController(AreasController(), animated:false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //隐藏navigationbar
        navigationController?.setNavigationBarHidden(true, animated:false)
    }

}
