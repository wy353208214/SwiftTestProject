//
//  WeatherController.swift
//  TestProject
//
//  Created by steven on 2021/9/27.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift

class WeatherController: UIViewController{

    private let address = UILabel()
    private let temperature = UILabel()
    private let weather = UILabel()
    
    private var area: AreaModel?
    private var weahterModel: WeatherModel?
    
    init(area: AreaModel) {
        super.init(nibName: nil, bundle: nil)
        self.area = area
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated:false)
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBlue
        self.view.addSubview(address)
        self.view.addSubview(temperature)
        self.view.addSubview(weather)
        
        address.font = UIFont.boldSystemFont(ofSize: 18)
        temperature.font = UIFont.boldSystemFont(ofSize: 54)
        weather.font = UIFont.boldSystemFont(ofSize: 20)
        address.textColor = UIColor.white
        temperature.textColor = UIColor.white
        weather.textColor = UIColor.white
        
        address.snp.makeConstraints{(make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        temperature.snp.makeConstraints{(make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(address.snp.bottom).offset(100)
        }
        weather.snp.makeConstraints{(make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperature.snp.bottom).offset(20)
        }
        
        getForecast(lng: area!.lng, lat: area!.lat, callBack: self.realCallBack(weatherModel:))
        
    }
    
    private func realCallBack(weatherModel: WeatherModel) {
        self.weather.text = weahterModel!.skycon
        self.address.text = self.area?.province
        self.temperature.text = "\(String(weahterModel!.temperature))℃"
    }
    
    func getForecast(lng: Double, lat: Double, callBack: @escaping(_ weatherModel: WeatherModel) -> Void){
        let url = "http://localhost:3000/weather/\(self.area!.code)/\(lng)/\(lat)/"
        print(url)
        AF.request(url).responseJSON{response in
            if let json = response.value {
                let dict = json as? NSDictionary
                let realtime = dict!["realtime"] as! NSDictionary
                print(realtime)
                let temperature = realtime["temperature"] as! NSNumber
                let skycon = realtime["skycon"] as! String
                let air_quality = realtime["air_quality"] as! NSDictionary
                let aqi = (air_quality["aqi"] as! NSDictionary)["chn"] as! Int
                let description = (air_quality["description"] as! NSDictionary)["chn"] as! String

                self.weahterModel = WeatherModel(aqi: aqi, description: description, temperature: temperature.stringValue, skycon: skycon)
                callBack(self.weahterModel!)
            }
        }
    }

    
}
