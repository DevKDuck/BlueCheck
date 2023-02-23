//
//  InvitePersonalInformationViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class InvitePersonalInformationViewController: UIViewController{
    
    let db = Firestore.firestore()
    var userUID: String = ""
    var userUidArray : [String] = []
    
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 작성해주세요"
        textField.backgroundColor = UIColor(hue: 0.55, saturation: 0.34, brightness: 1, alpha: 1.0)
        textField.textColor = .black
        return textField
    }()
    
    let userInfoOrWrongLabel : UILabel = {
        let label = UILabel()
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
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var searchUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("유저찾기", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        button.addTarget(self, action: #selector(tapSearchUserButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAddButton(_ sender: UIButton){
        userInfoOrWrongLabel.text = "추가되었습니다."
        userInfoOrWrongLabel.textColor = .systemBlue
        
    }
    
    @objc func tapSearchUserButton(_ sender: UIButton){
        //유저 찾기
        
        db.collection("user").getDocuments{ querySnapshot, error in
            for document in querySnapshot!.documents{
                let data = document.data()
                guard let userEmail = data["email"] as? String else { return }
                if let email = self.emailTextField.text {
                    if email == userEmail{
                        guard let userName = data["name"] as? String else { return }
                        guard let userUID = data["uid"] as? String else { return }
                        self.userInfoOrWrongLabel.text = userName + "님으로 확인되었습니다."
                        self.userInfoOrWrongLabel.textColor = .systemBlue
                        self.userUID = userUID
                    }
                    else{
                        self.userInfoOrWrongLabel.text = "유저의 정보를 찾을 수 없습니다."
                        self.userInfoOrWrongLabel.textColor = .systemRed
                    }
                }
            }
        }
        
    }
    
    
    @objc func tapInviteButton(_ sender: UIButton){
        //초대하는 사람의 uid를 추가
        let goInviteListViewController = InviteListViewController()
        goInviteListViewController.userUidArray = self.userUidArray
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
        
        self.view.addSubview(emailLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(userInfoOrWrongLabel)
        self.view.addSubview(addButton)
        self.view.addSubview(searchUserButton)
        self.view.addSubview(inviteButton)
        
        
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        userInfoOrWrongLabel.translatesAutoresizingMaskIntoConstraints = false
        searchUserButton.translatesAutoresizingMaskIntoConstraints = false
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            
            emailLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor,constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            userInfoOrWrongLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            userInfoOrWrongLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,constant: 10),
            
            
            searchUserButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchUserButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            searchUserButton.heightAnchor.constraint(equalToConstant: 44),
            searchUserButton.topAnchor.constraint(equalTo: self.userInfoOrWrongLabel.bottomAnchor, constant: 10),
            
            
            addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            addButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2 - 25),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            
            inviteButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            inviteButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2 - 25),
            inviteButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inviteButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            
        ])
        
        
    }
}
