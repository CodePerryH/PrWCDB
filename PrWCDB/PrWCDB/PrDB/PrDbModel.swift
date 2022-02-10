//
//  PrDbModel.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit
import WCDBSwift

//类型绑定
let userModelTableName  = "UserModel"
class UserModel: TableCodable {
    /// 主键自增id zhi
    var identifier: Int? = nil

    var uid: String = ""
    
    var name : String = ""

    
    var introduce : String = ""
    
    enum CodingKeys : String,CodingTableKey {
        typealias Root = UserModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier = "id"
        case uid
        case name
        case introduce
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true)
            ]
        }
    }
}
