//
//  CovidListController.swift
//  TestProject
//
//  Created by steven on 2021/8/17.
//  Copyright © 2021 qpidnetwork. All rights reserved.
//

import UIKit
import Alamofire

class CovidListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let CELL_ID = "CovidListController"
    private var datas = Array<CovidModel>()
    private let tableView = UITableView()
    private let offset = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated:false)
        self.view.backgroundColor = UIColor.white
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(CovidCell.classForCoder(), forCellReuseIdentifier: CELL_ID)
        

        //固定表头
        let stickyHeaderView = UIView()
        let textColor = UIColor.init(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        let backgroundColor = UIColor.init(red: 245/255, green: 246/255, blue: 247/255, alpha: 1)
        let areaLabel = CovidListController.generalLabel(text: "地区", textColor: textColor, backgroundcColor: backgroundColor)
        let newLabel = CovidListController.generalLabel(text: "新增", textColor: textColor, backgroundcColor: backgroundColor)
        let activeLabel = CovidListController.generalLabel(text: "现有", textColor: textColor, backgroundcColor: backgroundColor)
        let confirmedLabel = CovidListController.generalLabel(text: "累计", textColor: textColor, backgroundcColor: backgroundColor)
        let recoveredLabel = CovidListController.generalLabel(text: "治愈", textColor: textColor, backgroundcColor: backgroundColor)
        let deathLabel = CovidListController.generalLabel(text: "死亡", textColor: textColor, backgroundcColor: backgroundColor)
        
        //添加View
        stickyHeaderView.addSubview(areaLabel)
        stickyHeaderView.addSubview(newLabel)
        stickyHeaderView.addSubview(activeLabel)
        stickyHeaderView.addSubview(confirmedLabel)
        stickyHeaderView.addSubview(recoveredLabel)
        stickyHeaderView.addSubview(deathLabel)
        self.view.addSubview(stickyHeaderView)
        self.view.addSubview(tableView)

        //添加约束
        CovidListController.makeRowConstraints(items: areaLabel, newLabel, activeLabel, confirmedLabel, recoveredLabel, deathLabel, offset: 2, firstWidth: 90)
        stickyHeaderView.snp.makeConstraints{(make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        tableView.snp.makeConstraints{(make) -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalToSuperview()
            make.top.equalTo(stickyHeaderView.snp.bottom)
        }
        
        getDatas()
    }
    
    //定义静态方法给内部类调用，初始化UILabel
    class func generalLabel(text: String = "", textColor: UIColor, backgroundcColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = text
        label.textColor = textColor
        label.backgroundColor = backgroundcColor
        return label
    }
    
    //定义静态方法给内部类调用，设置约束
    class func makeRowConstraints(items: UIView..., offset: Float, firstWidth: Float = 80) {
        var before = UIView()
        
        for i in 0 ..< items.count {
            let item = items[i]
            if i == 0 {
                item.snp.makeConstraints{(make) -> Void in
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                    make.height.equalTo(40)
                    make.width.equalTo(firstWidth)
                }
            } else if i == (items.count - 1){
                item.snp.makeConstraints{(make) -> Void in
                    make.top.equalToSuperview()
                    make.left.equalTo(before.snp.right).offset(offset)
                    make.right.equalToSuperview()
                    make.height.equalTo(40)
                    make.width.equalTo(before)
                }
            } else {
                item.snp.makeConstraints{(make) -> Void in
                    make.top.equalToSuperview()
                    make.left.equalTo(before.snp.right).offset(offset)
                    make.height.equalTo(40)
                    if i != 1 {
                        make.width.equalTo(before)
                    }
                }
            }
            before = item
        }
    }
    
    //设置部分圆角
    func setCornerRadius(view: UIView!, radius: CGFloat, roundCorners: UIRectCorner) {
        if view == nil {
            return
        }
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: roundCorners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = datas[indexPath.row] as CovidModel
        
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = true
        nf.groupingSeparator = ","
        nf.groupingSize = 3
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! CovidCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.provinceLabel.text = item.province
        cell.newConfirmedLabel.text = nf.string(from: NSNumber(value: item.recovered))
        cell.totalConfirmedLabel.text = nf.string(from: NSNumber(value: item.confirmed))
        cell.deathdLabel.text = nf.string(from: NSNumber(value: item.deaths))
        cell.activedLabel.text = nf.string(from: NSNumber(value: item.active))
        cell.recoveredLabel.text = nf.string(from: NSNumber(value: item.recovered))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42

    }

    
    private func getDatas() {
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 60 * 60 * 24) //当前时间 - 1天的秒数 = 前1天
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: "UTC")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let stringDate = df.string(from: date)
        let requestUrl = "https://api.covid19api.com/live/country/china/status/confirmed/date/\(stringDate)"
        print(requestUrl)
        
        AF.request(requestUrl) {urlRequest in
            urlRequest.timeoutInterval = 10
        }.responseJSON { response in
            if let json = response.value {
                let dict = json as? NSArray
                if dict != nil {
                    for item in dict! {
                        let data = item as! NSDictionary
                        let id = data["ID"] as! String
                        let country = data["Country"] as! String
                        let countryCode = data["CountryCode"] as! String
                        let province = data["Province"] as! String
                        let confirmed = data["Confirmed"] as! Int
                        let deaths = data["Deaths"] as! Int
                        let recovered = data["Recovered"] as! Int
                        let active = data["Active"] as! Int
                        
                        //将2021-08-12T03:11:06Z格式转换为2021-08-12
                        var date = data["Date"] as! String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        let tmpDate = dateFormatter.date(from: date)
                        if tmpDate != nil {
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            date = dateFormatter.string(from: tmpDate!)
                        }

                        self.datas.append(CovidModel.init(id: id,
                                                          country: country,
                                                          countryCode: countryCode,
                                                          province: province,
                                                          confirmed: confirmed,
                                                          deaths: deaths,
                                                          recovered: recovered,
                                                          active: active,
                                                          date: date))
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    class CovidCell: UITableViewCell {
        
        let nomaltColor = UIColor.init(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
        let nomalbackgroundColor = UIColor.init(red: 245/255, green: 246/255, blue: 247/255, alpha: 1)
        let provinceBackgroundColor = UIColor.init(red: 0/255, green: 197/255, blue: 207/255, alpha: 1)
        
        var provinceLabel: UILabel!
        var newConfirmedLabel: UILabel!
        var activedLabel: UILabel!
        var totalConfirmedLabel: UILabel!
        var recoveredLabel: UILabel!
        var deathdLabel: UILabel!
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            provinceLabel = CovidListController.generalLabel(textColor: UIColor.white, backgroundcColor: provinceBackgroundColor)
            newConfirmedLabel = CovidListController.generalLabel(textColor: nomaltColor, backgroundcColor: nomalbackgroundColor)
            totalConfirmedLabel = CovidListController.generalLabel(textColor: nomaltColor, backgroundcColor: nomalbackgroundColor)
            deathdLabel = CovidListController.generalLabel(textColor: nomaltColor, backgroundcColor: nomalbackgroundColor)
            recoveredLabel = CovidListController.generalLabel(textColor: nomaltColor, backgroundcColor: nomalbackgroundColor)
            activedLabel = CovidListController.generalLabel(textColor: nomaltColor, backgroundcColor: nomalbackgroundColor)
            
            self.contentView.addSubview(provinceLabel)
            self.contentView.addSubview(newConfirmedLabel)
            self.contentView.addSubview(activedLabel)
            self.contentView.addSubview(totalConfirmedLabel)
            self.contentView.addSubview(recoveredLabel)
            self.contentView.addSubview(deathdLabel)
            
            makeRowConstraints(items: provinceLabel, newConfirmedLabel, activedLabel, totalConfirmedLabel, recoveredLabel, deathdLabel, offset: 0)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            //这里设置圆角是因为，init中添加约束拿不到bounds，此时bounds为0
            setCornerRadius(view: provinceLabel, radius: 4, roundCorners: [.topLeft, .bottomLeft])
            setCornerRadius(view: deathdLabel, radius: 4, roundCorners: [.topRight, .bottomRight])
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            fatalError("init(coder:) has not been implemented")
        }
        
        func setCornerRadius(view: UIView!, radius: CGFloat, roundCorners: UIRectCorner) {
            if view == nil {
                return
            }
            let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: roundCorners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.path = maskPath.cgPath
            view.layer.mask = maskLayer
        }
    
    }
}
