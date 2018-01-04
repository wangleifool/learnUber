//
//  SignUpViewModels.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/2.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModels {
    // 输入，从外部 Textfiled获取输入流
    let username = Variable<String>("")
    let passwd = Variable<String>("")
    let repeatPasswd = Variable<String>("")   
    let registerTaps = PublishSubject<Void>()
    
    
    // 输出流，具备标识 用户名是否有效 的 能力
    let usernameUsable:Observable<Result>
    let passwdUsable:Observable<Result>
    let repeatPasswdUsable:Observable<Result>
    
    let signupButtonEnable:Observable<Bool>
    
    let registerResult:Observable<Result>
    
    init() {
        let validateService = ValidateService.instance
        
        usernameUsable = username.asObservable()
                         .flatMapLatest({ username in
                            return validateService.validateUsername(username)
                                .observeOn(MainScheduler.instance)
                                .catchErrorJustReturn(.Failed(message: "username 检测出错"))
                         })
                         .share(replay: 1)
        
        passwdUsable = passwd.asObservable()
                    .map({ passwd in
                        return validateService.validatePasswdUsable(passwd)
                    })
                    .share(replay: 1)
        
        repeatPasswdUsable = Observable.combineLatest(passwd.asObservable(), repeatPasswd.asObservable())
                        .map({ (passwd, repeatPasswd) in
                            return validateService.validateRepeatPasswdUsable(passwd: passwd, repeatPasswd: repeatPasswd)
                        })
                        .share(replay: 1)
        
        
        // 只有👆三个都满足规则，才能启动注册按钮
        signupButtonEnable = Observable.combineLatest(usernameUsable, passwdUsable, repeatPasswdUsable)
                        .map({(usernameResult, passwdResult, repeatPasswdResult) in
                            return usernameResult.isValid && passwdResult.isValid && repeatPasswdResult.isValid
                        })
                        .distinctUntilChanged()  //只有 不同的情况下，才会传递事件
                        .share(replay: 1)
        
        let usernameAndPassword = Observable.combineLatest(username.asObservable(), passwd.asObservable()) {
            ($0, $1)
        }
        
        registerResult = registerTaps.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest { (inUsername, inPassword) in
                return validateService.registerUser(username: inUsername, password: inPassword)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.Failed(message: "注册出错"))
            }
            .share(replay: 1)
    }
    
}
