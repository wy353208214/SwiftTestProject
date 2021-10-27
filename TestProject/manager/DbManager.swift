//
//  DbManager.swift
//  TestProject
//
//  Created by Yang on 2021/8/26.
//  Copyright © 2021 hackyang. All rights reserved.
//

import Foundation
import SQLite
import RxSwift

final class DbManager{

    private var path = Bundle.main.path(forResource: "cn_area", ofType: "db")
    static let instance = DbManager()

    init() {
        copyDatabase()
    }
    
    func copyDatabase() {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        let copyPath = urls[0]
        let dbFile = copyPath.appendingPathComponent("cn_area.db")
        //先把db文件copy到沙盒中，如果db文件不存在就copy
        if !fm.fileExists(atPath: dbFile.path) {
            do {
                try fm.copyItem(atPath: self.path!, toPath: dbFile.path)
            }catch {
                print(error)
            }
        }
        self.path = dbFile.path
    }
    
    func query(p_code: Int = 0) -> Observable<Array<AreaModel>>?{
        if path == nil {
            return nil
        }
        var areaList = Array<AreaModel>()
        
        return Observable<Array<AreaModel>>.create { subcriber in
            do {
                let db = try Connection(self.path!)
                let areas = Table("area_code_2021")
                let code = Expression<Int>("code")
                let name = Expression<String>("name")
                let level = Expression<Int>("level")
                let pcode = Expression<Int>("pcode")
                let lng = Expression<Double>("lng")
                let lat = Expression<Double>("lat")
                
                let sql = areas.filter(pcode == p_code).order(code)
                for area in try db.prepare(sql) {
                    let areaModel = AreaModel(code: area[code], province: area[name], level: area[level], pcode: area[pcode], lng: area[lng], lat: area[lat])
                    areaList.append(areaModel)
                }
                subcriber.onNext(areaList)
            }catch {
                print (error)
            }
            subcriber.onCompleted()
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
        .observe(on: MainScheduler.instance)
    }
    
    func insert(areaModel: AreaModel) -> Int {
        var rowid = -1
        do {
            let db = try Connection(self.path!)
            let area = Table("area_code_2021")
            let code = Expression<Int>("code")
            let name = Expression<String>("name")
            let level = Expression<Int>("level")
            let pcode = Expression<Int>("pcode")
            let id = try db.run(area.insert(code <- areaModel.code, name <- areaModel.province, level <- areaModel.level, pcode <- areaModel.pcode))
            rowid = NSString(string: "\(id)").integerValue
        }catch {
            print(error)
        }
        return rowid
    }
    
    func queryCount(code: Int) -> Observable<Int> {
        return Observable<Int>.create{subcriber in
            var count = 0
            do {
                let db = try Connection(self.path!)
                let areas = Table("area_code_2021")
                let pcode = Expression<Int>("pcode")
                let sql = areas.filter(pcode == code).count
                try count = db.scalar(sql)
                subcriber.onNext(count)
            }catch {
                print(error)
            }
            subcriber.onCompleted()
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
        .observe(on: MainScheduler.instance)
    }
    
}
