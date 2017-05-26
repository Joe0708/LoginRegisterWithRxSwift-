//
//  LoginViewController.swift
//  LoginRegisterWithRxSwift
//
//  Created by Joe on 2017/5/26.
//  Copyright © 2017年 Joe. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = LoginViewModel(
            input: (
                username: usernameTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                loginTaps: loginButton.rx.tap.asDriver()),
            service: ValidationService.instance)
        
        viewModel.usernameUsable
            .drive(usernameTextField.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.loginButtonEnabled
            .drive(loginButton.rx.isEnableAlpha)
            .addDisposableTo(disposeBag)
        
        viewModel.loginResult
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
    }
    
    func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
    }
}
