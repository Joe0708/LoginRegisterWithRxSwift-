//
//  RegisterViewModel.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    // input
    //    let username = Variable<String>("")
    //    let password = Variable<String>("")
    //    let repeatPassword = Variable<String>("")
    //    let registerTaps = PublishSubject<Void>()
    
    // output
    let usernameUsable: Driver<Result>
    let passwordUsable: Driver<Result>
    let repeatPasswordUsable: Driver<Result>
    let registerButtonEnabled: Driver<Bool>
    let registerResult: Driver<Result>
    
    init(input: (
        username: Driver<String>,
        password: Driver<String>,
        repeatPassword: Driver<String>,
        registerTaps: Driver<Void>
        ),
         service: ValidationService
        ) {
        
        usernameUsable = input.username
            .flatMapLatest { username in
                service.validateUsername(username).asDriver(onErrorJustReturn: .failed(message: "未知错误"))
        }
        
        passwordUsable = input.password
            .map { return service.validatePassword( $0 ) }
        
        repeatPasswordUsable = Driver.combineLatest(input.password, input.repeatPassword) {
            return service.validateRepeatPassword($0, repeatPassword: $1)
        }
        
        registerButtonEnabled = Driver.combineLatest(usernameUsable, passwordUsable, repeatPasswordUsable) {
            $0.isValid && $1.isValid && $2.isValid
            }.distinctUntilChanged()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            ($0, $1)
        }
        
        registerResult = input.registerTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest {
                return service.register($0, password: $1)
                    .asDriver(onErrorJustReturn: .failed(message: "注册失败"))
        }
        
        //        usernameUsable = input.username
        //            .flatMapLatest { username in
        //                service.validateUsername(username)
        ////                return service.validateUsername(username)
        ////                    .observeOn(MainScheduler.instance)
        ////                    .catchErrorJustReturn(Result.failed(message: "出错"))
        //            }
        //
        //        passwordUsable = input.password.asObservable()
        //            .map { password in
        //                return service.validatePassword(password)
        //            }
        //
        //        repeatPasswordUsable = Observable.combineLatest(input.password.asObservable(), input.repeatPassword){
        //            return service.validateRepeatPassword($0, repeatPassword: $1)
        //            }
        //
        //        registerButtonEnabled = Observable.combineLatest(
        //            usernameUsable,
        //            passwordUsable,
        //            repeatPasswordUsable){ (username, password, repeatPassword) in
        //
        //                username.isValid && password.isValid && repeatPassword.isValid
        //            }.distinctUntilChanged()
        //            .shareReplay(1)
        //
        //        let usernameAndPassword = Observable.combineLatest(
        //            username.asObservable(),
        //            password.asObservable()){
        //                ( $0, $1 )
        //        }
        //
        //        registerResult = registerTaps.asObserver().withLatestFrom(usernameAndPassword)
        //            .flatMapLatest { (username, password) in
        //                return service.register(username, password: password)
        //                    .observeOn(MainScheduler.instance)
        //                    .catchErrorJustReturn(Result.failed(message: "注册出错"))
        //            }.shareReplay(1)
    }
}

