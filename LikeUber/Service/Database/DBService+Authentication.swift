//
//  DBService+Authentication.swift
//  LikeUber
//
//  Created by wanglei on 2018/8/24.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation
import SQLite

extension DBService {
    func insertAuthentication(username: String, passwd: String) -> Bool {
        do {
            try db?.run(AuthenticationTB.table.insert(or: .replace,
                                                    AuthenticationTB.userName <- username,
                                                    AuthenticationTB.password <- passwd))
        } catch {
            print("Authentication insert fail \(error)")
            return false
        }
        return true
    }

    func checkIfExisted(username: String) -> Bool {
        do {
            let query = AuthenticationTB.table.filter(AuthenticationTB.userName == username)
            let count = try db?.scalar(query.count)
            return count ?? 0 > 0
        } catch {
            print("check if existed account fail \(error)")
        }
        return false
    }

    func checkIfCorrect(username: String, passwd: String) -> Bool {
        do {
            let query = AuthenticationTB.table.filter(AuthenticationTB.userName == username &&
                                                      AuthenticationTB.password == passwd)
            let count = try db?.scalar(query.count)
            return count ?? 0 > 0
        } catch {
            print("check if existed account fail \(error)")
        }
        return false
    }
}
