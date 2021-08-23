//
//  PageViewController.swift
//  TestProject
//
//  Created by steven on 2021/8/12.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class PageViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {

    private var controllers = [GalleryController(), GalleryController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
    
        
//        let customContainer = UIView()
//        self.view.addSubview(customContainer)
//        customContainer.snp.makeConstraints{(make)-> Void in
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//            make.width.equalToSuperview()
//            make.height.equalTo(96)
//        }
        
        let bar = TMBar.ButtonBar()
//        bar.backgroundColor = UIColor.blue
//        bar.indicator.tintColor = UIColor.orange
        bar.buttons.customize{(button) in
            button.selectedTintColor = UIColor.orange
            button.font = UIFont.systemFont(ofSize: 20)
        }
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        addBar(bar, dataSource: self, at: .top)
        
    
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return controllers.count
    }

    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return controllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return Page.first
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: "Page \(index)")
    }
    
}
