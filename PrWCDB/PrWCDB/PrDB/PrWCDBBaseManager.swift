//
//  PrWCDBManagement.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit
import Foundation
import WCDBSwift
/*
 0
 1、模型 绑定
 2、 操作数据库 增 删 改 查
 3、 事务
 4、 高级功能 加密与配置
 5、 链式调用 遍历查询 联表查询 核心层接口
 6、 监控与错误处理  自定义字段映射类型  全文搜索 损坏、备份、修复
 */

///数据库路径
fileprivate struct WCDataBasePath{
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! + "/PrWCDB/Test.db"
}

class PrWCDBBaseManager : NSObject{
    
    static let shared = PrWCDBBaseManager()
    
    let  dbPath = URL(fileURLWithPath: WCDataBasePath().dbPath)
    
    var dataBase : Database?
    
    private override init() {
        super.init()

        dataBase = creteDb()
    }
    
    ///创建数据库
    private func creteDb() -> Database {
        return Database(withFileURL: dbPath)
    }
    ///创建数据库表
    func createTable<T:TableDecodable>(table: String, of type:T.Type){
        do {
            try dataBase?.create(table: table, of: type)
        } catch let error {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    
    ///插入
    ///propertyConvertibleList 字段可以指定插入的字段，其它未指定的用默认值代替
    ///插入是最常用且比较容易操作卡顿的操作，因此 WCDB Swift 对其进行了特殊处理。 当插入的对象数大于 1 时，WCDB Swift 会自动开启事务，进行批量化地插入，以获得更新的性能。
    func insertToDb<T: TableEncodable>(objects: [T],intoTable table : String) {
        do {
            try dataBase?.insertOrReplace(objects: objects, intoTable: table)
        } catch let error {
            debugPrint("insert table error \(error.localizedDescription)")

        }
    }
    
    ///修改
    func updateToDb<T : TableEncodable>(table: String, on propertys:[PropertyConvertible],with object:T,where condition: Condition? = nil){
        do {
            try dataBase?.update(table: table, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint("update table error \(error.localizedDescription)")
        }
        
    }

    
    /// 删除操作
    /// - Parameters:
    ///   - fromTable: 表
    ///   - condition: 条件
    func deleteFromDb(fromTable: String, where condition: Condition? = nil){
        do {
            try dataBase?.delete(fromTable: fromTable, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    ///查询
    func qureyFromDb<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase?.getObjects(fromTable: fromTable, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    ///删除数据表
    func dropTable(table : String) {
        do {
            try dataBase?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error.localizedDescription)")
        }
    }
    ///删除所有与该数据库相关的文件
    func removeDbFile(){
        do {
            try dataBase?.close(onClosed: {
                try dataBase?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error.localizedDescription)")
        }
    }
    
}
