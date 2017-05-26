//
//  Protocol.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension Result {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return .green
        case .empty:
            return .black
        case .failed:
            return .red
        }
    }
}

extension Result {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
}

extension Reactive where Base: UITextField{
    var validationResult: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base) { textField, result in
            textField.textColor = result.textColor
//            textField.text = result.description
        }
    }
}


extension Reactive where Base: UITextField{
    var inputEnabled: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base) { textFiled, result in
            textFiled.isEnabled = result.isValid
        }
    }
}

extension Reactive where Base: UIButton{
    var isEnableAlpha: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base) { button, valid in
            button.isEnabled = valid
            button.alpha = valid ? 1.0 : 0.5
        }
    }
}
