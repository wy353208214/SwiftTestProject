//
//  AreaModel.swift
//  TestProject
//
//  Created by steven on 2021/8/26.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import Foundation

struct AreaModel {
    var code: Int = -1
    var province: String = ""
    var level: Int = -1
    var pcode: Int = -1
    
    init(code: Int, province: String, level: Int, pcode: Int) {
        self.code = code
        self.province = province
        self.level = level
        self.pcode = pcode
    }
}
