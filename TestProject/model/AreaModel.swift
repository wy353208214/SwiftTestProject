//
//  AreaModel.swift
//  TestProject
//
//  Created by Yang on 2021/8/26.
//  Copyright © 2021 hackyang. All rights reserved.
//

import Foundation

struct AreaModel {
    var code: Int
    var province: String
    var level: Int
    var pcode: Int
    var lng: Double
    var lat: Double
    
    init(code: Int = -1, province: String = "", level: Int = -1, pcode: Int = -1, lng:Double = -1.0
         , lat: Double = -1.0) {
        self.code = code
        self.province = province
        self.level = level
        self.pcode = pcode
        self.lng = lng
        self.lat = lat
    }
}
