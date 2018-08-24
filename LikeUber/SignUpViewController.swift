//
//  SignUpViewController.swift
//  RxSwiftTest
//
//  Created by lei wang on 2018/1/2.
//  Copyright © 2018年 lei wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Spring

class SignUpViewController: WLBasePageViewController {

    @IBOutlet weak var usernameTextfiled: UITextField!
    @IBOutlet weak var usernameHintLabel: UILabel!
    
    @IBOutlet weak var passwdTextfield: UITextField!
    @IBOutlet weak var passwdHintLabel: UILabel!
    
    @IBOutlet weak var repeatPasswdTextfiled: UITextField!
    @IBOutlet weak var repeatPasswdHintLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: SpringImageView!
    @IBOutlet weak var btSignUp: UIButton!
    @IBOutlet weak var infoStackView: UIStackView!

    var avatarImage: UIImage?
    
    let viewModel = SignUpViewModels()  //抽象出 视图模型层，逻辑代码放在这里面处理
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "注册账户"
        
        // Do any additional setup after loading the view.
        configureUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avatarImageView.animate()
    }

    func Done() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    //绑定UI与模型的关系
    func configureUI() {

        avatarImageView.image = avatarImage
        passwdTextfield.isSecureTextEntry = true
        repeatPasswdTextfiled.isSecureTextEntry = true

        btSignUp.layer.cornerRadius = btSignUp.bounds.height/2
        btSignUp.layer.addSublayer(UIColor.setGradualChangingColor(view: btSignUp, fromColor: "007EF9", toColor: "7A7EF9"))
        
        usernameTextfiled.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: usernameHintLabel.rx.validateResult)
            .disposed(by: disposeBag)
        
        viewModel.usernameUsable
            .bind(to: passwdTextfield.rx.inputEnabled)
            .disposed(by: disposeBag)
        
        
        // 密码文本框 输入流
        passwdTextfield.rx.text.orEmpty
            .bind(to: viewModel.passwd)
            .disposed(by: disposeBag)
        
        // 密码文本框 输出流
        viewModel.passwdUsable
            .bind(to: passwdHintLabel.rx.validateResult)
            .disposed(by: disposeBag)
        
        viewModel.passwdUsable
            .bind(to: repeatPasswdTextfiled.rx.inputEnabled)
            .disposed(by: disposeBag)
        
        
        // 重复密码文本框 输入流
        repeatPasswdTextfiled.rx.text.orEmpty
            .bind(to: viewModel.repeatPasswd)
            .disposed(by: disposeBag)
        
        // 重复密码文本框 输出流
        viewModel.repeatPasswdUsable
            .bind(to: repeatPasswdHintLabel.rx.validateResult)
            .disposed(by: disposeBag)
        
        
        // 监听按钮是否 可用
        viewModel.signupButtonEnable
            .subscribe(onNext: { [unowned self] valid in   // unowned 表示 self 在闭包里，不会强引用，避免内存泄漏
                self.btSignUp.isEnabled = valid
                self.btSignUp.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
        
        
        btSignUp.rx.tap
            .bind(to: viewModel.registerTaps)
            .disposed(by: disposeBag)
        
        viewModel.registerResult
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .Ok(_):
                    self?.showSucAlert()
                case let .Failed(message):
                    self?.showAlert(description: message)
                case .Empty:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    func showSucAlert() {
        let alert = SuccessAlertView.instance()
        alert.message = "注册成功"
        alert.closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.Done()
            })
            .disposed(by: disposeBag)
        alert.show()
    }

    func showAlert(description: String) {
        let alertControler = UIAlertController(title: "Hint", message: description, preferredStyle: .alert)
        alertControler.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
        present(alertControler, animated: true, completion: nil)
    }
}
