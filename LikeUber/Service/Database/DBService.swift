//
//  DBService.swift
//  LikeUber
//
//  Created by 王雷 on 2018/6/25.
//  Copyright © 2018年 wanglei. All rights reserved.
//

import Foundation
import SQLite

class DBService {

    static let shared = DBService()

    let path = PathConst.docPath
    var db: Connection? = try? Connection(PathConst.docPath + PathConst.dbPath)
    private init() {
        do {
            try db?.transaction {
                createAuthenticationTb()
            }
        } catch {
            print(error)
        }
    }

    private func createAuthenticationTb() {
        do {
            try db?.run(AuthenticationTB.table.create(ifNotExists: true,
                                                      block: { (table) in
                table.column(AuthenticationTB.userName, primaryKey: true)
                table.column(AuthenticationTB.password)
            }))
        } catch {
            print("创建认证表失败")
        }
    }
}

struct AuthenticationTB {
    static let table = Table("Authentication")
    static let userName = Expression<String>("username")
    static let password = Expression<String>("password")
}
