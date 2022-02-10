//
//  AppDelegate.swift
//  PrWCDB
//
//  Created by admin on 2022/2/9.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        createWcdbTable()
        
        window?.rootViewController  = ListTableViewController()

        window?.makeKeyAndVisible()
        return true
    }

    /// 创建数据库-表
    func createWcdbTable()
    {
        PrWCDBBaseManager.shared.createTable(table: userModelTableName, of: UserModel.self)
    }

}

