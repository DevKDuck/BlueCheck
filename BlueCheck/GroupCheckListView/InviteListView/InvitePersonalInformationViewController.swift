//
//  InvitePersonalInformationViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/02.
//

import UIKit

class InvitePersonalInformationViewController: UIViewController{
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 작성해주세요"
        textField.backgroundColor = UIColor(hue: 0.55, saturation: 0.34, brightness: 1, alpha: 1.0)
        textField.textColor = .black
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 작성해주세요"
        textField.backgroundColor = UIColor(hue: 0.55, saturation: 0.34, brightness: 1, alpha: 1.0)
        textField.textColor = .black
        return textField
    }()
    
    let wrongLabel : UILabel = {
        let label = UILabel()
        label.text = "유저의 정보를 찾을 수 없습니다."
        label.textColor = .red
        return label
    }()
    
    
    lazy var inviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("초대하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tapInviteButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc func tapInviteButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayoutConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(nameLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(wrongLabel)
        self.view.addSubview(inviteButton)
//        self.view.addSubview(stackView)
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        wrongLabel.translatesAutoresizingMaskIntoConstraints = false
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
//            stackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
//            stackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
            
            nameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant:20),
            
            
            nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor,constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),

            emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor,constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            inviteButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            inviteButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inviteButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inviteButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            wrongLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            wrongLabel.bottomAnchor.constraint(equalTo: self.inviteButton.topAnchor,constant: -30),

            
        ])
        
//        [nameLabel,nameTextField,emailLabel
//         ,emailTextField,wrongLabel,inviteButton,stackView].map{
//            self.stackView.addArrangedSubview($0)
//        }
    }
}
