//
//  LoginViewModels.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/3.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class loginViewModels {
    // 输入流
    let username = Variable<String>("")
    let password = Variable<String>("")
    let loginTap = PublishSubject<Void>() // 上层传来的点击事件
    
    // 输出流
    let usernameUsable:Observable<Result>
    let loginButtonUsable:Observable<Bool>
    let loginResult:Observable<Result>
    
    init() {
        
        let validateService = ValidateService.instance
        
        usernameUsable = username.asObservable()
            .flatMapLatest({ userName in
                return validateService.loginValidateUsername(userName)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.Failed(message: "验证用户名出错"))                    
            })
            .share(replay: 1)
        
        loginButtonUsable = password.asObservable()
            .map({
                return $0.count > 0
            })
        
        // 生成一个 observable元组
        let usernameAndPassword = Observable.combineLatest(username.asObservable(),password.asObservable()) {
            ($0,$1)
        }
        
        
        loginResult = loginTap.asObserver().withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (inUsername,inPassword) in
                return validateService.login(username: inUsername, password: inPassword)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.Failed(message: "登录验证出错"))
            })
        
    }
}
