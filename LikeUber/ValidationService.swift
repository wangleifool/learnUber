//
//  ValidationService.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/2.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation
import RxSwift

class ValidateService {
    static let instance = ValidateService()
    private init() {}
    
    
    func loginValidateUsername(_ username: String) -> Observable<Result> {
        if username.count == 0 {
            return .just(.Empty)
        }
        
        if isExistedUser(username) {
            return .just(.Ok(message: "用户存在"))
        }
        
        return .just(.Failed(message: "用户不存在"))
    }
    
    func login(username name:String, password passwd:String) -> Observable<Result> {
        
        let documentPath = NSHomeDirectory() + "/Documents/users.plist"
        if let dicData = NSDictionary(contentsOfFile: documentPath) {
            
            if let userPass = dicData.object(forKey: name) as? String {
                if  userPass == passwd {
                    return .just(.Ok(message: "登录成功"))
                }
            }
            return .just(.Failed(message: "密码错误"))
            
        } else {
            return .just(.Failed(message: "用户不存在"))
        }
    }
    
    func validateUsername(_ username: String) -> Observable<Result> {
        if username.count == 0 {
            return .just(.Empty)
        }
        
        if username.count <= MinUsernameLength {
            return .just(.Failed(message: "用户名长度至少大于6个字符"))
        }
        
        if isExistedUser(username) {
            return .just(.Failed(message: "用户名已经存在"))
        }
        
        return .just(.Ok(message: "用户名符合要求"))
    }
    
    
    
    // 这里返回值 为Result，而不是 Observable<Result>，故意展现不同的情景 可以使用不同的用法。
    // 在验证username是否有效，我们假设会网络或本地数据库操作，相对耗时。所以我们把验证通过 Observable 包装了一下，在外部使用的时候，应该使用FlatMap 转换成新的 事件通道 才对。
    // 而这里，假设是不耗时的操作，直接返回结果， 外部使用的时候，直接使用Map，对事件队列 调整一下内容， 继续使用原先的 事件通道才对
    func validatePasswdUsable(_ passwd: String) -> Result {
        if passwd.count == 0 {
            return .Empty
        }
        
        if passwd.count <= MinPasswdLength {
            return .Failed(message: "密码至少6位数")
        }
        
        return .Ok(message: "密码符合规则")
    }
    
    func validateRepeatPasswdUsable(passwd pswd: String ,repeatPasswd rePswd: String) -> Result {
        if rePswd.count == 0 {
            return .Empty
        }
        
        if pswd == rePswd {
            return .Ok(message: "密码匹配")
        }
        
        return .Failed(message: "两次密码输入不匹配")
    }
    
    func isExistedUser(_ username: String) -> Bool {
        let documentPath = NSHomeDirectory() + "/Documents/users.plist"
        if let dicData = NSDictionary(contentsOfFile: documentPath) {
            
            let allKeys = dicData.allKeys as NSArray
            if allKeys.contains(username) {
                return true
            } else {
                return false
            }
            
        } else {
            return false
        }
        
    }
    
    func registerUser(username name:String, password passwd:String) -> Observable<Result> {
        let documentPath = NSHomeDirectory() + "/Documents/users.plist"
        let dic = [name:passwd]
        
        if (dic as NSDictionary).write(toFile: documentPath, atomically: true) {
            return .just(.Ok(message: "注册成功"))
        }
        
        return .just(.Failed(message: "注册失败"))
    }
}

