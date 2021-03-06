//
//  AreasController.swift
//  TestProject
//
//  Created by Yang on 2021/8/31.
//  Copyright © 2021 hackyang. All rights reserved.
//

import UIKit
import Toast_Swift

class AreasController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var areas = Array<AreaModel>()
    private let tableView = UITableView()
    private let CELL_ID = "AreasCell"
    private var pcode: Int = 0
    
    public var areaDelegate: AreaDelegate?
    
    init(pcode: Int = 0, areaDelegate: AreaDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.pcode = pcode
        self.areaDelegate = areaDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //显示navigationbar
        navigationController?.setNavigationBarHidden(false, animated:false)
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.addArea))
        self.navigationItem.rightBarButtonItem = buttonItem
        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{(make) -> Void in
            make.size.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CELL_ID)
        
        let dbm = DbManager.instance
        dbm.query(p_code: pcode)?.subscribe(
            onNext: {row in
                self.areas.append(contentsOf: row)
            },
            onCompleted: {
                self.tableView.reloadData()
            }
        )
    }
    
    @objc func addArea() {
        let alertController = UIAlertController(title: "添加省份", message: "请输入省份信息", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField{(textField: UITextField!) -> Void in
                textField.placeholder = "code"
        }
        alertController.addTextField{(textField) -> Void in
            textField.placeholder = "省份"
        }
        alertController.addTextField{(textField) -> Void in
            textField.placeholder = "Level"
        }
        alertController.addTextField{(textField) -> Void in
            textField.placeholder = "PCode"
        }
        
        let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) {
            (action) -> Void in
            let code = Int((alertController.textFields?[0].text)!)
            let province = alertController.textFields?[1].text
            let level = Int((alertController.textFields?[2].text)!)
            let pCode = Int((alertController.textFields?[3].text)!)

            if code == nil || province == nil || level == nil || pCode == nil {
                self.view.makeToast("不能为nil")
                return
            }

            //插入数据库
            let dbm = DbManager.instance
            let rowid = dbm.insert(areaModel: AreaModel(code: code!, province: province!, level: level!, pcode: pCode!))
            self.view.makeToast("RowID is \(rowid)")
            print(rowid)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let area = areas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell.textLabel?.text = area.province
        
        cell.contentView.tag = indexPath.row
        cell.contentView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(itemClick(tab:)))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        cell.contentView.addGestureRecognizer(tap)
        return cell
    }
    
    @objc func itemClick(tab: UIGestureRecognizer) {
        let position = (tab.view?.tag)! as Int
        let area = areas[position]
        //这里查询是否还有下一级区域，如果没有就直接跳转到天气详情页面
        DbManager.instance.queryCount(code: area.code).subscribe(
            onNext: {count in
                if count != 0 && area.level < 3 {
                    let controller = AreasController.init(pcode: self.areas[position].code,areaDelegate: self.areaDelegate)
                    self.navigationController?.pushViewController(controller, animated: true)
                }else {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.areaDelegate?.onSelect(area: area)
                }
            }
        )
    }

}
