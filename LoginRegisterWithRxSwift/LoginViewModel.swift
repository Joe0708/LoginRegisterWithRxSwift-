//
//  LoginViewModel.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // output
    let usernameUsable: Driver<Result>
    let loginButtonEnabled: Driver<Bool>
    let loginResult: Driver<Result>
    
    
    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        loginTaps: Driver<Void>
        ),
         service: ValidationService
        ) {
        
        usernameUsable = input.username.flatMapLatest { username in
            service.validLoginUsername(username).asDriver(onErrorJustReturn: .failed(message: "无法连接到服务器"))
        }
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { ($0, $1) }
        
        loginResult = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
                return service.login(username, password: password)
                    .asDriver(onErrorJustReturn: .failed(message: "无法连接到服务器"))
        }
        
        loginButtonEnabled = input.password
            .map { $0.characters.count > 3 }.asDriver()
    }
    
}
