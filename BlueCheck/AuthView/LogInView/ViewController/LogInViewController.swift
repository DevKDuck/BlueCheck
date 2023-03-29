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
import AuthenticationServices
import CryptoKit

class LogInViewController: UIViewController{
    
    
    var userSession: FirebaseAuth.User?
    var currentUser: User?
    
    static let shared = LogInViewController() //싱글톤..... 추후에 구성해보자
    
    let blueCheckMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Blue Check"
        label.font = UIFont.MaplestoryFont(type: .Bold, size: 30)
        label.textColor = .systemBlue

        return label
    }()
    
    let logInLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: " 이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: " 비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var autoLogInCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.addTarget(self, action: #selector(tapAutoLogInButton(_:)), for: .touchUpInside)
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
                Auth.auth().signIn(withEmail: idText, password: passwordText){ [weak self](result, error) in
                    guard let self = self else {return}
                    if result != nil{
                        print("success")
                        
                        //MARK: ID,PASSWORD 저장
                        if self.autoLogInCheckButton.isSelected {
                            UserDefaults.standard.set(idText, forKey: "id")
                            UserDefaults.standard.set(passwordText, forKey: "password")
                        }
                        //MARK: 여기 수정햇음
                        //                        guard let user = result?.user else {return}
                        
                        let vc = TabbarViewController()
                        
                        vc.currentUserEmail = idText
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
    
    func autoLogin(){
        if let userid = UserDefaults.standard.string(forKey: "id"), let userpw = UserDefaults.standard.string(forKey: "password"){
            Auth.auth().signIn(withEmail: userid, password: userpw){ (result, error) in
                
                if result != nil{
                    
                    //                    guard let user = result?.user else {return}
                    
                    let vc = TabbarViewController()
                    
                    vc.currentUserEmail = userid
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                    
                }
                else{
                    self.logInErrorLabel.text = "자동 로그인 실패 - 아이디,비밀번호를 확인해주세요!!"
                }
            }
            
            
        }else{
            print("AutoLogin failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    lazy var findIDButton:  UIButton = {
        let button = UIButton()
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
        button.addTarget(self, action: #selector(tapFindIDorPassword(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var findPasswordButton:  UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .light)
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
        label.font = UIFont.MaplestoryFont(type: .Light, size: 15)
        return label
    }()
    
    let passwordNextdivideLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .black
        label.font = UIFont.MaplestoryFont(type: .Light, size: 15)
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
    
    
    lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(tapAppleButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAppleButton(_ sender: UIButton){
        startSignInWithAppleFlow()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        buttonConfiguration()
        setLayoutConstraints()
        autoLogin()
        
        
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
    
    @objc func tapAutoLogInButton(_ sender: UIButton){
        autoLogInCheckButton.isSelected.toggle()
        let autoLogInImage = autoLogInCheckButton.isSelected ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        autoLogInCheckButton.setImage(autoLogInImage, for: .normal)
    }
    
    
    
    private func setLayoutConstraints(){
        
        self.view.addSubview(blueCheckMainLabel)
        self.view.addSubview(logInLabel)
        self.view.addSubview(idTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(passwordEyebutton)
        self.view.addSubview(autoLogInCheckButton)
        self.view.addSubview(logInErrorLabel)
        self.view.addSubview(logInbutton)

        self.view.addSubview(findIdPassWordAndJoinMembershipStackView)
        self.view.addSubview(sNSLeftLineView)
        self.view.addSubview(sNSRightLineView)
        self.view.addSubview(sNSLogInLable)
        self.view.addSubview(appleButton)
        
        
        
        blueCheckMainLabel.translatesAutoresizingMaskIntoConstraints = false
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordEyebutton.translatesAutoresizingMaskIntoConstraints = false
        autoLogInCheckButton.translatesAutoresizingMaskIntoConstraints = false
        logInErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        logInbutton.translatesAutoresizingMaskIntoConstraints = false

        findIdPassWordAndJoinMembershipStackView.translatesAutoresizingMaskIntoConstraints = false
        sNSLeftLineView.translatesAutoresizingMaskIntoConstraints = false
        sNSRightLineView.translatesAutoresizingMaskIntoConstraints = false
        sNSLogInLable.translatesAutoresizingMaskIntoConstraints = false
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            blueCheckMainLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20),
            blueCheckMainLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            
            logInLabel.topAnchor.constraint(equalTo: blueCheckMainLabel.bottomAnchor,constant: 15),
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
        
            
//            logInAnonouncementButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
//            logInAnonouncementButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            
            logInbutton.topAnchor.constraint(equalTo: self.autoLogInCheckButton.bottomAnchor, constant: 10),
            logInbutton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            logInbutton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            logInbutton.bottomAnchor.constraint(equalTo: self.logInAnonouncementButton.topAnchor,constant: -15),
            logInbutton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logInbutton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logInbutton.heightAnchor.constraint(equalToConstant: 44),
            

            logInErrorLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logInErrorLabel.topAnchor.constraint(equalTo: logInbutton.bottomAnchor,constant: 10),
            logInErrorLabel.heightAnchor.constraint(equalToConstant: 44),
            
            
            findIdPassWordAndJoinMembershipStackView.topAnchor.constraint(equalTo: self.logInErrorLabel.bottomAnchor, constant: 20),
            findIdPassWordAndJoinMembershipStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            findIdPassWordAndJoinMembershipStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: view.bounds.width / 10),
            findIdPassWordAndJoinMembershipStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -(view.bounds.width / 10)),
            
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
            
            appleButton.topAnchor.constraint(equalTo: self.sNSLogInLable.bottomAnchor,constant: 20),
            appleButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            appleButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            appleButton.heightAnchor.constraint(equalToConstant: 44),
            
//            logInErrorLabel.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 15),
//            logInErrorLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            logInErrorLabel.heightAnchor.constraint(equalToConstant: 30),
//
            
        ])
    }
    fileprivate var currentNonce: String?
}

extension LogInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                
                
                Firestore.firestore().collection("user").document(authResult?.user.email ?? "").getDocument { document,err  in
                    if let err = err{
                        print("Firestore Apple SignIn Error: \(err.localizedDescription)")
                    }
                    else{
                        if document?.exists == true{
                            goTabbarViewController()
                        }
                        else{
                            
                            let data = ["email" : authResult?.user.email, "name" : "이름을 설정해주세요", "uid" : authResult?.user.uid, "nickName" : "닉네임을 설정해주세요"]
                            
                            Firestore.firestore().collection("user").document(authResult?.user.email ?? "").setData(data as [String : Any]){ error in
                                if let error = error{
                                    print("DEBUG:\(error.localizedDescription)")
                                    return
                                }
                            }
                            
                        }
                    }
                }
                
                
                goTabbarViewController()
                
                
                func goTabbarViewController(){
                    let tabbarViewController = TabbarViewController()
                    tabbarViewController.currentUserEmail = authResult?.user.email ?? ""
                    tabbarViewController.modalPresentationStyle = .fullScreen
                    self.present(tabbarViewController, animated: true)
                }
            }
        }
    }
}

//Apple Sign in
extension LogInViewController {
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LogInViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
