//
//  JoinTheMembershipViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/09.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import FirebaseAuth


class JoinTheMembershipViewController: UIViewController{
    
    let blueCheckLabel : UILabel = {
        let label = UILabel()
        label.text = "Blue Check"
        label.textColor = .systemBlue
        label.font = UIFont.MaplestoryFont(type: .Bold, size: 30)
        return label
    }()
    
    let joinRequestPhrasesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.MaplestoryFont(type: .Light, size: 13)
        label.text = "지인들과 리스트를 \n 공유하면서 목표에 도전해보세요 💪"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    
    let errorLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        return label
    }()
    
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .systemBlue
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .systemBlue
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .systemBlue
        
        return label
    }()
    
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let passwordLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .systemBlue
        
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "6글자 이상"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let passwordConfirmLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = .systemBlue
        return label
    }()
    
    let passwordConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "6글자 이상"
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    lazy var jointheMembershipButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapJointheMembershipButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func tapJointheMembershipButton(_ sender: UIButton){
        
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text, let passwordConfirmText = passwordConfirmTextField.text, let nameText = nameTextField.text, let nickNmaeText = nickNameTextField.text {
            
            if emailText.isEmpty || passwordText.isEmpty || passwordConfirmText.isEmpty || nameText.isEmpty || nickNmaeText.isEmpty{
                if emailText.isEmpty{
                    self.errorLabel.text = "이메일을 작성해주세요"
                }
                else if nameText.isEmpty{
                    self.errorLabel.text = "이름을 작성해주세요"
                }
                else if nickNmaeText.isEmpty{
                    self.errorLabel.text = "닉네임을 작성해주세요"
                }
                
                else if passwordText.isEmpty {
                    self.errorLabel.text = "비밀번호을 작성해주세요"
                }
                else if passwordConfirmText.isEmpty{
                    self.errorLabel.text = "비밀번호 확인 부분을 작성해주세요"
                }
            }
            else{
                if passwordTextField.text == passwordConfirmTextField.text{
                    
                    if let link = UserDefaults.standard.string(forKey: "Link"){
                        if Auth.auth().isSignIn(withEmailLink: link){
                            Auth.auth().createUser(withEmail: emailText, password: passwordText){ (result,error) in
                                if result != nil {
                                    print("register success")
                                    
                                    guard let user = result?.user else {return} //유저 객체를 가져옴
                                    
                                    //전달할 데이터
                                    let data = ["email": emailText, "name": nameText, "uid": user.uid, "nickName": nickNmaeText ]
                                    
                                    
                                    Firestore.firestore().collection("user").document(emailText).setData(data){ error in
                                        if let error = error{
                                            print("DEBUG:\(error.localizedDescription)")
                                            return
                                        }
                                        else{
                                            print("Firestore \(emailText) SetData Success")
                                        }
                                    }
                                    
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                                else{
                                    if let maybeError = error{
                                        let err = maybeError as NSError
                                        switch err.code{
                                        case AuthErrorCode.invalidEmail.rawValue:
                                            self.errorLabel.text = "이메일 형식이 잘못되었습니다."
                                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                                            self.errorLabel.text = "이미 사용중인 이메일입니다."
                                        case AuthErrorCode.weakPassword.rawValue:
                                            self.errorLabel.text = "암호는 6글자 이상이어야 합니다"
                                        default:
                                            print("unknow error:\(err.localizedDescription)")
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            self.errorLabel.text = "비밀번호가 같지 않습니다."
                        }
                    }
                    else{
                        let alert = UIAlertController(title: "이메일 인증 필요", message: "이메일 인증을 누르시고 \n 작성하신 이메일에서 인증을 완료해주세요!!", preferredStyle: .alert)
                        let confirm = UIAlertAction(title: "확인", style: .cancel)
                        
                        alert.addAction(confirm)
                        
                        present(alert, animated: false)
                        
                    }
                }
                
            }
        }
    }
    
    let logInBoundaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    let logInLabel : UILabel = {
        let label = UILabel()
        label.text = "이미 가입하셨다면 로그인버튼을 눌러주세요!"
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    
    lazy var logInButton : UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(tapLogInButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var logInStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.logInLabel,self.logInButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    @objc func tapLogInButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(hue: 0.55, saturation: 0.34, brightness: 1, alpha: 1.0)
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var sendEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapSendEmailButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapSendEmailButton(_ sender: UIButton){
        
        guard let email = emailTextField.text else {return}
        
        if email.isEmpty {
            self.errorLabel.text = "이메일 작성 후 인증버튼을 눌러주세요"
        }
        else{
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string:"https://bluecheck-b090c.firebaseapp.com/?email=\(email)")
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            
            Auth.auth().sendSignInLink(toEmail: email,
                                       actionCodeSettings: actionCodeSettings) { error in
                // ...
                if let error = error {
                    print(error.localizedDescription)
                    self.errorLabel.text = "잘못된 이메일입니다."
                    return
                }
                let alert = UIAlertController(title: "이메일 전송 완료", message: "작성하신 이메일에서 인증해주세요", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "확인", style: .cancel)
                
                alert.addAction(cancel)
                
                self.present(alert, animated: false)
                print("To: \(email) send Email Success")
            }
        }
    }
    
    private func setLayoutConstraints(){
        
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        view.addSubview(blueCheckLabel)
        view.addSubview(joinRequestPhrasesLabel)
        view.addSubview(errorLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmLabel)
        view.addSubview(passwordConfirmTextField)
        view.addSubview(jointheMembershipButton)
        view.addSubview(logInBoundaryView)
        view.addSubview(logInStackView)
        
        view.addSubview(sendEmailButton)
        
        
        blueCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        joinRequestPhrasesLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        jointheMembershipButton.translatesAutoresizingMaskIntoConstraints = false
        logInBoundaryView.translatesAutoresizingMaskIntoConstraints = false
        logInStackView.translatesAutoresizingMaskIntoConstraints = false
        
        sendEmailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            contentScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1.2),
            
            blueCheckLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            blueCheckLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: view.bounds.height / 12),
            
            joinRequestPhrasesLabel.topAnchor.constraint(equalTo: self.blueCheckLabel.bottomAnchor,constant: 20),
            joinRequestPhrasesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: joinRequestPhrasesLabel.bottomAnchor,constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor,constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            nameTextField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            
            nickNameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 10),
            nickNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            nickNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            nickNameTextField.topAnchor.constraint(equalTo: self.nickNameLabel.bottomAnchor,constant: 10),
            nickNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nickNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordLabel.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor,constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor,constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordConfirmLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 10),
            passwordConfirmLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            passwordConfirmTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            passwordConfirmTextField.topAnchor.constraint(equalTo: self.passwordConfirmLabel.bottomAnchor,constant: 10),
            passwordConfirmTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 44),
            
            errorLabel.topAnchor.constraint(equalTo: passwordConfirmTextField.bottomAnchor,constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            
            jointheMembershipButton.topAnchor.constraint(equalTo: self.errorLabel.bottomAnchor,constant: 10),
            jointheMembershipButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            jointheMembershipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            jointheMembershipButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            logInBoundaryView.topAnchor.constraint(equalTo: self.jointheMembershipButton.bottomAnchor,constant: 10),
            logInBoundaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 40),
            logInBoundaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -40),
            logInBoundaryView.heightAnchor.constraint(equalToConstant: 2),
            
            logInButton.heightAnchor.constraint(equalToConstant: 44),
            logInButton.widthAnchor.constraint(equalToConstant: 75),
            
            
            logInStackView.topAnchor.constraint(equalTo: self.logInBoundaryView.bottomAnchor,constant: 15),
            logInStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            
            sendEmailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            sendEmailButton.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10),
            sendEmailButton.heightAnchor.constraint(equalToConstant: 44),
            sendEmailButton.widthAnchor.constraint(equalToConstant: 75),
            
        ])
    }
    
}


