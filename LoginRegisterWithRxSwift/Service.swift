//
//  Service.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import Foundation
import RxSwift

class ValidationService {
    
    static let instance = ValidationService()
    
    let minCharactersCount = 6
    
    let maxCharactersCount = 20

}


// MARK: - 注册
extension ValidationService {
    func validateUsername(_ username: String) -> Observable<Result> {
        
        if username.characters.count < 1 {
            return Observable.just(Result.empty)
        }
        
        if username.characters.count < minCharactersCount{
            return Observable.just(Result.failed(message: "用户名至少6个字符"))
        }
        
        if username.characters.count > maxCharactersCount {
            return Observable.just(Result.failed(message: "用户名最大20个字符"))
        }
        
        if validUsernameIsExist(username) {
            return Observable.just(Result.failed(message: "用户名已存在"))
        }
        
        return Observable.just(Result.ok(message: "用户名可用"))
    }
    
    func validatePassword(_ password: String) -> Result {
        
        if password.characters.count < 1  {
            return Result.empty
        }
        
        if password.characters.count < minCharactersCount {
            return Result.empty
        }
        
        return Result.ok(message: "密码可用")
    }
    
    func validateRepeatPassword(_ password: String, repeatPassword: String) -> Result {
        if repeatPassword.characters.count < 0 {
            return Result.empty
        }
        
        if repeatPassword != password {
            return Result.failed(message: "两次密码不一样")
        }
        
        return Result.ok(message: "两次密码一样")
    }
    
    
    fileprivate func validUsernameIsExist(_ username: String) -> Bool {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        let usernameArray = userDic!.allKeys as NSArray
        return usernameArray.contains(username)
    }
    
    func register(_ username: String, password: String) -> Observable<Result> {
        let userDic = [username: password]
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
            return .just(.ok(message: "注册成功"))
        }
        return .just(.failed(message: "注册失败"))
    }
}


// MARK: - 登录
extension ValidationService {
    
    func validLoginUsername(_ username: String) -> Observable<Result> {
//        if username.characters.count <= 1 {
//            return Observable.just(Result.empty)
//        }
        
        if username.characters.count <= minCharactersCount {
            return Observable.just(Result.empty)
        }
        
        if validUsernameIsExist(username) {
            return Observable.just(Result.ok(message: "用户名可用"))
        }
        
        return Observable.just(Result.failed(message: "用户名不存在"))
    }
    
    func login(_ username: String, password: String) -> Observable<Result> {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        if let userPassword = userDic?.object(forKey: username) as? String {
            if userPassword == password {
                return Observable.just(Result.ok(message: "登录成功"))
            }
        }
        return Observable.just(Result.failed(message: "密码错误"))
    }
}
