//
//  FindIDPasswordViewContoller.swift
//  BlueCheck
//
//  Created by duck on 2023/02/09.
//

import UIKit

class FindIDPasswordViewContoller: UIViewController{
    
    //MARK: 임시 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("<--", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    @objc func tapBackButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    let findIDLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디 찾기"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()

    let idPartEmailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    let passwordPartEmailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    

    let findPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 찾기"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var idPartSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tapidPartSearchButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapidPartSearchButton(_ sender: UIButton){
        let alert = UIAlertController(title: "아이디 전송 완료", message: "이메일에서 아이디를 확인해주세요.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .cancel){ cancel in
            alert.dismiss(animated: true)
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true)
    }
    
    lazy var passwordPartSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tapPasswordPartSearchButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapPasswordPartSearchButton(_ sender: UIButton){
        let alert = UIAlertController(title: "비밀번호 전송 완료", message: "이메일에서 비밀번호를 확인해주세요.", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .cancel){ cancel in
            alert.dismiss(animated: true)
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setLayoutConstraints()
        
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(backButton)
        
        self.view.addSubview(findIDLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(idPartEmailField)
        self.view.addSubview(idPartSearchButton)
        
        
        self.view.addSubview(findPasswordLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(passwordPartEmailField)
        self.view.addSubview(passwordPartSearchButton)
        
       
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        findIDLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        idPartEmailField.translatesAutoresizingMaskIntoConstraints = false
        idPartSearchButton.translatesAutoresizingMaskIntoConstraints = false
        findPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordPartEmailField.translatesAutoresizingMaskIntoConstraints = false
        passwordPartSearchButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            
            
            
            findIDLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90),
            findIDLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: self.findIDLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            idPartEmailField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10),
            idPartEmailField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idPartEmailField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idPartEmailField.heightAnchor.constraint(equalToConstant: 44),
            
            idPartSearchButton.topAnchor.constraint(equalTo: self.idPartEmailField.bottomAnchor, constant: 20),
            idPartSearchButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idPartSearchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idPartSearchButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            findPasswordLabel.topAnchor.constraint(equalTo: self.idPartSearchButton.bottomAnchor, constant: 30),
            findPasswordLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            idTextField.topAnchor.constraint(equalTo: self.findPasswordLabel.bottomAnchor, constant: 20),
            idTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            passwordPartEmailField.topAnchor.constraint(equalTo: self.idTextField.bottomAnchor, constant: 10),
            passwordPartEmailField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordPartEmailField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordPartEmailField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordPartSearchButton.topAnchor.constraint(equalTo: self.passwordPartEmailField.bottomAnchor, constant: 20),
            passwordPartSearchButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordPartSearchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordPartSearchButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            
        ])
    }
}
