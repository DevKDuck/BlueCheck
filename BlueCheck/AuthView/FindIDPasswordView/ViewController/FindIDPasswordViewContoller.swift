//
//  FindIDPasswordViewContoller.swift
//  BlueCheck
//
//  Created by duck on 2023/02/09.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FindIDPasswordViewContoller: UIViewController{
    
    //MARK: 임시 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
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
    
    let idPartNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: " 이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()

    let idPartEmailField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: " 이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    let passwordPartNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: " 이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    let passwordPartEmailField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: " 이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        textField.layer.borderWidth = 1
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
        guard let emailText = idPartEmailField.text else {return}
        Firestore.firestore().collection("user").document(emailText).getDocument{ document, error in
            
            if let error = error{
                print("GetDocument user Error: \(error.localizedDescription)")
            }
            else{
                if document?.exists == false{
                    self.executeAlertController("잘못된 정보입니다.", "이메일과 이름을 확인해주세요")
                }
                else{
                    guard let document = document else{return}
                    guard let data = document.data() else {return}
                    guard let firestoreName = data["name"] as? String else {return}
                    guard let name = self.idPartNameTextField.text else {return}
                    
                    if firestoreName != name{
                        self.executeAlertController("잘못된 정보입니다.", "이메일과 이름을 확인해주세요")
                    }
                    else{
                        self.executeAlertController(emailText, "존재하는 이메일입니다.")
                    }
                }
            }
        }
    }
    
    func executeAlertController(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
        guard let emailText = passwordPartEmailField.text else {return}
        
        Firestore.firestore().collection("user").document(emailText).getDocument{ document, error in
            
            if let error = error{
                print("GetDocument user Error: \(error.localizedDescription)")
            }
            else{
                if document?.exists == false{
                    self.executeAlertController("잘못된 정보입니다.", "이메일과 이름을 확인해주세요")
                }
                else{
                    guard let document = document else{return}
                    guard let data = document.data() else {return}
                    guard let firestoreName = data["name"] as? String else {return}
                    guard let name = self.passwordPartNameTextField.text else {return}
                    
                    if firestoreName != name{
                        self.executeAlertController("잘못된 정보입니다.", "이메일과 이름을 확인해주세요")
                    }
                    else{
                        Auth.auth().sendPasswordReset(withEmail: emailText){ error in
                            if let error = error{
                                print("SendPasswordReset Email Error: \(error.localizedDescription)")
                            }
                            else{
                                self.executeAlertController("비밀번호 변경 메일전송 완료", "이메일에서 비밀번호를 변경해주세요.")
                            }
                        }
                        
                    }
                }
            }
        }
        
        
        Auth.auth().sendPasswordReset(withEmail: emailText){ error in
            let alert = UIAlertController(title: "비밀번호 변경 메일전송 완료", message: "이메일에서 비밀번호를 변경해주세요.", preferredStyle: .alert)

            let confirm = UIAlertAction(title: "확인", style: .cancel){ cancel in
                alert.dismiss(animated: true)
            }
            alert.addAction(confirm)

            self.present(alert, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setLayoutConstraints()
        
    }
    
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(backButton)
        
        self.view.addSubview(findIDLabel)
        self.view.addSubview(idPartNameTextField)
        self.view.addSubview(idPartEmailField)
        self.view.addSubview(idPartSearchButton)
        
        
        self.view.addSubview(findPasswordLabel)
        self.view.addSubview(passwordPartNameTextField)
        self.view.addSubview(passwordPartEmailField)
        self.view.addSubview(passwordPartSearchButton)
        
       
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        findIDLabel.translatesAutoresizingMaskIntoConstraints = false
        idPartNameTextField.translatesAutoresizingMaskIntoConstraints = false
        idPartEmailField.translatesAutoresizingMaskIntoConstraints = false
        idPartSearchButton.translatesAutoresizingMaskIntoConstraints = false
        findPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordPartNameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordPartEmailField.translatesAutoresizingMaskIntoConstraints = false
        passwordPartSearchButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            
            
            
            findIDLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 90),
            findIDLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            idPartNameTextField.topAnchor.constraint(equalTo: self.findIDLabel.bottomAnchor, constant: 20),
            idPartNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idPartNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idPartNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            idPartEmailField.topAnchor.constraint(equalTo: self.idPartNameTextField.bottomAnchor, constant: 10),
            idPartEmailField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idPartEmailField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idPartEmailField.heightAnchor.constraint(equalToConstant: 44),
            
            idPartSearchButton.topAnchor.constraint(equalTo: self.idPartEmailField.bottomAnchor, constant: 20),
            idPartSearchButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idPartSearchButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idPartSearchButton.heightAnchor.constraint(equalToConstant: 44),
            
            
            findPasswordLabel.topAnchor.constraint(equalTo: self.idPartSearchButton.bottomAnchor, constant: 30),
            findPasswordLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            passwordPartNameTextField.topAnchor.constraint(equalTo: self.findPasswordLabel.bottomAnchor, constant: 20),
            passwordPartNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordPartNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordPartNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            passwordPartEmailField.topAnchor.constraint(equalTo: self.passwordPartNameTextField.bottomAnchor, constant: 10),
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
