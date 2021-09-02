//
//  CovidModel.swift
//  TestProject
//
//  Created by Yang on 2021/8/17.
//  Copyright © 2021 hackyang. All rights reserved.
//

import Foundation

struct CovidModel {
    var id: String
    var country: String
    var countryCode: String
    var province: String
    var confirmed: Int
    var deaths: Int
    var recovered: Int
    var active: Int
    var date: String
    
    init(id: String, country: String, countryCode: String, province: String, confirmed: Int, deaths: Int, recovered: Int, active: Int, date: String) {
        self.id = id
        self.country = country
        self.countryCode = countryCode
        self.province = province
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.active = active
        self.date = date
    }
    
}
