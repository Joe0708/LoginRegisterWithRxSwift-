//
//  ViewController.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }
    
    func setupRx() {
        
        let viewModel = RegisterViewModel(input: (
            username: usernameTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            repeatPassword: repeatPasswordTextField.rx.text.orEmpty.asDriver(),
            registerTaps: registerButton.rx.tap.asDriver()), service: ValidationService.instance)
        
        // input
        //        usernameTextField.rx.text.orEmpty
        //            .bind(to: viewModel.username)
        //            .addDisposableTo(disposeBag)
        //
        //        passwordTextField.rx.text.orEmpty
        //            .bind(to: viewModel.password)
        //            .addDisposableTo(disposeBag)
        //
        //        repeatPasswordTextField.rx.text.orEmpty
        //            .bind(to: viewModel.repeatPassword)
        //            .addDisposableTo(disposeBag)
        //
        //        registerButton.rx.tap
        //            .bind(to: viewModel.registerTaps)
        //            .addDisposableTo(disposeBag)
        //
        // output
        
        viewModel.usernameUsable
            .throttle(0.5)
            .drive(usernameTextField.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.usernameUsable
            .drive(passwordTextField.rx.inputEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.passwordUsable
            .drive(passwordTextField.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.repeatPasswordUsable
            .drive(repeatPasswordTextField.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.registerButtonEnabled
            .drive(registerButton.rx.isEnableAlpha)
            .addDisposableTo(disposeBag)
        
        viewModel.registerResult
            .drive(onNext: { [unowned self] result in
                switch result {
                case let .ok(message):
                    self.showAlert(message: message)
                case let .failed(message):
                    self.showAlert(message: message)
                case .empty:
                    self.showAlert(message: "")
                }
            }).addDisposableTo(disposeBag)
        
        //        viewModel.usernameUsable
        //            .throttle(0.5, scheduler: MainScheduler.instance)
        //            .bind(to: usernameTextField.rx.validationResult)
        //            .addDisposableTo(disposeBag)
        //
        //        viewModel.usernameUsable
        //            .bind(to: passwordTextField.rx.inputEnabled)
        //            .addDisposableTo(disposeBag)
        //
        //
        //        viewModel.passwordUsable
        //            .bind(to: passwordTextField.rx.validationResult)
        //            .addDisposableTo(disposeBag)
        //
        //        viewModel.passwordUsable
        //            .bind(to: repeatPasswordTextField.rx.inputEnabled)
        //            .addDisposableTo(disposeBag)
        //
        //        viewModel.repeatPasswordUsable
        //            .bind(to: repeatPasswordTextField.rx.validationResult)
        //            .addDisposableTo(disposeBag)
        //
        //        viewModel.registerButtonEnabled
        //            .bind(to: registerButton.rx.isEnableAlpha)
        //            .addDisposableTo(disposeBag)
        //
        //        viewModel.registerResult
        //            .subscribe(onNext: { [unowned self] reuslt in
        //                switch reuslt {
        //                case let .ok(message):
        //                    self.showAlert(message: message)
        //                case let .failed(message):
        //                    self.showAlert(message: message)
        //                case .empty:
        //                    self.showAlert(message: "")
        //                }
        //            }).addDisposableTo(disposeBag)
    }
    
    func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
    }
}

