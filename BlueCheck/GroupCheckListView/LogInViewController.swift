//
//  LogInViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/08.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class LogInViewController: UIViewController{
    
    
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    static let shared = LogInViewController()
    
    
    
  
    
    let logInLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.textColor = .darkGray
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = .darkGray
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let autoLogInCheckButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        return button
    }()
    
//    let autoLogInLabel: UILabel = {
//        let label = UILabel()
//        label.text = "자동 로그인"
//        label.textColor = .black
//        label.font = .systemFont(ofSize: 10, weight: .black)
//        return label
//    }()
    
    let logInErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    lazy var logInbutton : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapLogInButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapLogInButton(_ sender: UIButton) {
        
        if let idText = idTextField.text, let passwordText = passwordTextField.text{
            if idText.isEmpty || passwordText.isEmpty{
                self.logInErrorLabel.text = "아이디,비밀번호를 입력해주세요!!"
            }
            else{
                Auth.auth().signIn(withEmail: idText, password: passwordText){ (result, error) in
                    
                    if result != nil{
                        print("success")
                        
                        guard let user = result?.user else {return}
                        self.currentUser = user
                        
                        
//                        self.dismiss(animated: true)
                        
                        let vc = GroupListViewController()
                        vc.currentUser = user
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        
                    }
                    else{
                        self.logInErrorLabel.text = "아이디,비밀번호를 확인해주세요!!"
                    }
                }
            }
        }
    }
    
    
    
    lazy var passwordEyebutton : UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.addTarget(self, action: #selector(tapPasswordEyebutton(_:)), for: .touchUpInside)
         
        return button
    }()
    
    @objc func tapPasswordEyebutton(_ sender: UIButton){
        passwordTextField.isSecureTextEntry.toggle()
        passwordEyebutton.isSelected.toggle()
        
        let eyeImage = passwordEyebutton.isSelected ? UIImage(systemName: "eye.fill") : UIImage(systemName: "eye.slash.fill")
        passwordEyebutton.setImage(eyeImage, for: .normal)
    }
    
        
    let logInAnonouncementButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인에 어려움이 있으신가요?", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()
    
    
    lazy var findIDButton:  UIButton = {
        let button = UIButton()
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(tapFindIDorPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var findPasswordButton:  UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(tapFindIDorPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var joinTheMembershipButton:  UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.addTarget(self, action: #selector(tapJoinTheMembershipButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapJoinTheMembershipButton (_ sender: UIButton) {
        let presentJoinTheMembershipViewController = JoinTheMembershipViewController()
        
        presentJoinTheMembershipViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(presentJoinTheMembershipViewController, animated: true)
//        self.present(presentJoinTheMembershipViewController, animated: true)
    }
    
    let idNextdivideLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let passwordNextdivideLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    @objc func tapFindIDorPassword(_ sender: UIButton){
        let presentFindIDPasswordViewContoller = FindIDPasswordViewContoller()
        presentFindIDPasswordViewContoller.modalPresentationStyle = .fullScreen
        self.present(presentFindIDPasswordViewContoller, animated: true)
    }
    
    
    lazy var findIdPassWordAndJoinMembershipStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [findIDButton, idNextdivideLabel, findPasswordButton, passwordNextdivideLabel, joinTheMembershipButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let sNSLeftLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let sNSRightLineView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    
    let sNSLogInLable: UILabel = {
        let label = UILabel()
        label.text = "SNS 계정으로 로그인"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let kakaotalkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        return button
    }()
    
    let naverButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    
    let appleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    
    lazy var sNSButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kakaotalkButton,naverButton,appleButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        buttonConfiguration()
        setLayoutConstraints()
        
    }
    
    func buttonConfiguration(){
        var config = UIButton.Configuration.plain()
        config.title = "자동 로그인"
        config.image = UIImage(systemName: "checkmark.square")
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        autoLogInCheckButton.configuration = config
    }
    
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(logInLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordEyebutton)
        self.view.addSubview(autoLogInCheckButton)
        self.view.addSubview(logInErrorLabel)
        self.view.addSubview(logInbutton)
        self.view.addSubview(logInAnonouncementButton)
        self.view.addSubview(findIdPassWordAndJoinMembershipStackView)
        self.view.addSubview(sNSLeftLineView)
        self.view.addSubview(sNSRightLineView)
        self.view.addSubview(sNSLogInLable)
        self.view.addSubview(sNSButtonStackView)
        
        
        
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordEyebutton.translatesAutoresizingMaskIntoConstraints = false
        autoLogInCheckButton.translatesAutoresizingMaskIntoConstraints = false
        logInErrorLabel.translatesAutoresizingMaskIntoConstraints = false
//        autoLogInLabel.translatesAutoresizingMaskIntoConstraints = false
        logInbutton.translatesAutoresizingMaskIntoConstraints = false
        logInAnonouncementButton.translatesAutoresizingMaskIntoConstraints = false
        findIdPassWordAndJoinMembershipStackView.translatesAutoresizingMaskIntoConstraints = false
        sNSLeftLineView.translatesAutoresizingMaskIntoConstraints = false
        sNSRightLineView.translatesAutoresizingMaskIntoConstraints = false
        sNSLogInLable.translatesAutoresizingMaskIntoConstraints = false
        sNSButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            logInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 50),
            logInLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logInLabel.heightAnchor.constraint(equalToConstant: 44),
            
            
            idTextField.topAnchor.constraint(equalTo: self.logInLabel.bottomAnchor,constant: 7),
            idTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            idTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 44),
            

            passwordTextField.topAnchor.constraint(equalTo: self.idTextField.bottomAnchor,constant: 7),
            passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordEyebutton.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor),
            passwordEyebutton.trailingAnchor.constraint(equalTo: self.passwordTextField.trailingAnchor, constant: -10),
            passwordEyebutton.heightAnchor.constraint(equalToConstant: 40),
            passwordEyebutton.widthAnchor.constraint(equalToConstant: 40),
            
            autoLogInCheckButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor,constant: 20),
            autoLogInCheckButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            autoLogInCheckButton.heightAnchor.constraint(equalToConstant: 30),
            
            logInErrorLabel.topAnchor.constraint(equalTo: self.autoLogInCheckButton.bottomAnchor, constant: 10),
            logInErrorLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logInErrorLabel.heightAnchor.constraint(equalToConstant: 30),
    
            
            logInAnonouncementButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            logInAnonouncementButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
    
            
            logInbutton.topAnchor.constraint(equalTo: self.logInErrorLabel.bottomAnchor, constant: 10),
            logInbutton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logInbutton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logInbutton.bottomAnchor.constraint(equalTo: self.logInAnonouncementButton.topAnchor,constant: -15),
            
            findIdPassWordAndJoinMembershipStackView.topAnchor.constraint(equalTo: self.logInAnonouncementButton.bottomAnchor, constant: 20),
            findIdPassWordAndJoinMembershipStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            findIdPassWordAndJoinMembershipStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            findIdPassWordAndJoinMembershipStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            sNSLogInLable.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            sNSLogInLable.topAnchor.constraint(equalTo: self.findIdPassWordAndJoinMembershipStackView.bottomAnchor, constant: 30),
            
            sNSRightLineView.leadingAnchor.constraint(equalTo: self.sNSLogInLable.trailingAnchor, constant: 5),
            sNSRightLineView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sNSRightLineView.centerYAnchor.constraint(equalTo: self.sNSLogInLable.centerYAnchor),
            sNSRightLineView.heightAnchor.constraint(equalToConstant: 2),

            
            sNSLeftLineView.trailingAnchor.constraint(equalTo: self.sNSLogInLable.leadingAnchor, constant: -5),
            sNSLeftLineView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sNSLeftLineView.centerYAnchor.constraint(equalTo: self.sNSLogInLable.centerYAnchor),
            sNSLeftLineView.heightAnchor.constraint(equalToConstant: 2),
            
            sNSButtonStackView.topAnchor.constraint(equalTo: self.sNSLogInLable.bottomAnchor, constant: 20),
            sNSButtonStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            sNSButtonStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            sNSButtonStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            sNSButtonStackView.heightAnchor.constraint(equalToConstant: 44)
            

        ])
    }
}
