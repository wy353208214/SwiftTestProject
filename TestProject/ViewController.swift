//
//  ViewController.swift
//  TestProject
//
//  Created by steven on 2021/7/27.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import SnapKit

class ViewController: UIViewController {

    private let WIDTH = CGFloat(180)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "hello world hello world hello world hello world "
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.blue
        //限制最大宽度及行数，超过宽度显示为...省略号
        label.preferredMaxLayoutWidth = WIDTH - 20
        label.numberOfLines = 0
         
    
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("我是一个按钮", for: UIControl.State.normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        let box = UIView()
        box.backgroundColor = UIColor.orange
        
        let child = UIView()
        child.backgroundColor = UIColor.black
        
        
        box.addSubview(child)
        self.view.addSubview(box)
        self.view.addSubview(label)
        self.view.addSubview(button)
        
        
        child.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        box.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(10)
            make.left.equalTo(child.snp.left).offset(-10)
            make.right.equalTo(child.snp.right).offset(10)
            make.bottom.equalTo(child.snp.bottom).offset(10)
            
        }
        
        
        label.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }

        button.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        button.addTarget(self, action: #selector(self.onClick), for: UIControl.Event.touchUpInside)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.goGallery))
        tap.numberOfTapsRequired = 1
        box.isUserInteractionEnabled = true
        box.addGestureRecognizer(tap)
        
        

    
//        let contenView = ContentView()
        // Do any additional setup after loading the view.
    }
    
    @objc func onClick(){
        self.navigationController?.pushViewController(PhtotoDetailController(), animated:true)
        //模态跳转Modal
//        present(PhtotoDetailController(), animated: true)
    }
    
    @objc func goGallery() {
        self.navigationController?.pushViewController(GalleryController(), animated:false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //隐藏navigationbar
        navigationController?.setNavigationBarHidden(true, animated:false)
    }

}
