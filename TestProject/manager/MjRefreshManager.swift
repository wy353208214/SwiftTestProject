//
//  MjRefreshManager.swift
//  TestProject
//
//  Created by steven on 2021/9/22.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import Foundation
import MJRefresh

final class MjRefreshManager{
    
    
    static let instance = MjRefreshManager()
    
    func GifFooter(target: Any, action: Selector) -> MJRefreshFooter{
        var images = Array<UIImage>()
        images.append(UIImage.init(named: "dropdown_loading_01")!)
        images.append(UIImage.init(named: "dropdown_loading_02")!)
        images.append(UIImage.init(named: "dropdown_loading_03")!)
        
        var idleImages = Array<UIImage>()
        idleImages.append(UIImage.init(named: "dropdown_loading_01")!)
        
        var pullImages = Array<UIImage>()
        pullImages.append(UIImage.init(named: "dropdown_loading_03")!)
        
        let footer = MJRefreshBackGifFooter.init(refreshingTarget: target, refreshingAction: action)
        footer.setImages(images,for: MJRefreshState.refreshing)
        footer.setImages(pullImages,for: MJRefreshState.pulling)
        footer.setImages(idleImages,for: MJRefreshState.idle)
        return footer
    }
    
}
