//
//  JoinTheMembershipViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/09.
//

import UIKit

class JoinTheMembershipViewController: UIViewController{
    
    
    let blueCheckLabel : UILabel = {
        let label = UILabel()
        label.text = "Blue Check"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    
    let joinRequestPhrasesLabel : UILabel = {
        let label = UILabel()
        label.text = "지인들과 리스트를 \n 공유하면서 목표에 도전해보세요!."
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    let idLabel : UILabel = {
        let label = UILabel()
        label.text = "아이디"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
   
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일 주소"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
   
    
    
    let passwordLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
   
    
    let passwordConfirmLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var jointheMembershipButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(tapJointheMembershipButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapJointheMembershipButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hue: 0.55, saturation: 0.34, brightness: 1, alpha: 1.0)
        
        setLayoutConstraints()
        
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(blueCheckLabel)
        self.view.addSubview(joinRequestPhrasesLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(idLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordConfirmLabel)
        self.view.addSubview(passwordConfirmTextField)
        self.view.addSubview(jointheMembershipButton)
        

        blueCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        joinRequestPhrasesLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        jointheMembershipButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blueCheckLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            blueCheckLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 40),
            
            joinRequestPhrasesLabel.topAnchor.constraint(equalTo: self.blueCheckLabel.bottomAnchor,constant: 20),
            joinRequestPhrasesLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: joinRequestPhrasesLabel.bottomAnchor,constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            nameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            idLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 20),
            idLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            idTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            idTextField.topAnchor.constraint(equalTo: self.idLabel.bottomAnchor,constant: 10),
            idTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            idTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            
            emailLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor,constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            emailTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor,constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor,constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordConfirmLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 20),
            passwordConfirmLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            
            passwordConfirmTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            passwordConfirmTextField.topAnchor.constraint(equalTo: self.passwordConfirmLabel.bottomAnchor,constant: 10),
            passwordConfirmTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 44),
            
            jointheMembershipButton.topAnchor.constraint(equalTo: self.passwordConfirmTextField.bottomAnchor,constant: 40),
            jointheMembershipButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            jointheMembershipButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            jointheMembershipButton.heightAnchor.constraint(equalToConstant: 50)
           
            
            
            
            
        ])
        
        
    }
    
}


