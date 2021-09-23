//
//  MovieItem.swift
//  TestProject
//
//  Created by steven on 2021/9/17.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import Foundation
struct MovieModel {
    var cover = ""
    var title = ""
    var topicDesc = ""
    var vid = ""
    var mp4_url = ""
    var m3u8_url = ""
    var length = 0
    
    init(cover: String, title: String, topicDesc: String, vid: String, mp4_url: String, m3u8_url: String, length: Int) {
        self.cover = cover
        self.title = title
        self.topicDesc = topicDesc
        self.m3u8_url = m3u8_url
        self.vid = vid
        self.mp4_url = mp4_url
        self.length = length
    }
}
