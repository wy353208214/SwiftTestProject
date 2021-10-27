//
//  WeatherModel.swift
//  TestProject
//
//  Created by steven on 2021/10/11.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import Foundation
struct WeatherModel {
    
    var aqi: Int
    var description: String
    var temperature: String
    var skycon: String
    
    init(aqi: Int = -1, description: String = "", temperature: String = "", skycon: String = "") {
        self.aqi = aqi
        self.description = description
        self.temperature = temperature
        self.skycon = skycon
    }
    
}
