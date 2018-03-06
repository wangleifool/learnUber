//
//  LoginViewController.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/2.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

let MinUsernameLength = 3
let MinPasswdLength = 6


class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var usernameHintLabel: UILabel!
    
    @IBOutlet weak var passwdTextfiled: UITextField!    
    
    @IBOutlet weak var btLogin: UIButton!
    
    
    let viewModel = loginViewModels()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI() {
        usernameTextfiled.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: usernameHintLabel.rx.validateResult)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: passwdTextfiled.rx.inputEnabled)
            .disposed(by: disposeBag)
        
        
        // viewModels 里 的 password 监听 输入框的 输入事件
        passwdTextfiled.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        // 鉴定 view modle 的 按钮是否可用
        viewModel.loginButtonUsable
            .subscribe(onNext: { [unowned self] valid in
                self.btLogin.isEnabled = valid
                self.btLogin.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        // 按钮事件流
        btLogin.rx.tap
            .bind(to: viewModel.loginTap)
            .disposed(by: disposeBag)
        
        viewModel.loginResult
            .subscribe(onNext: {[unowned self]  result in
                switch result {
                case let .Ok(message):
                    self.showAlert(description: message)
                case .Empty:
                    self.showAlert(description: "")
                case let .Failed(message):
                    self.showAlert(description: message)
                }
            })
            .disposed(by: disposeBag)
    }
   
    @IBAction func btLoginPressed(_ sender: Any) {
        
    }
    
    func showAlert(description: String) {
        let alertControler = UIAlertController(title: "Hint", message: description, preferredStyle: .alert)
        alertControler.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        present(alertControler, animated: true, completion: nil)
    }
}
