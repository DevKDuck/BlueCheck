//
//  MyProfileSettingController.swift
//  BlueCheck
//
//  Created by duck on 2023/03/02.
//

import UIKit
import FirebaseFirestore


class MyProfileSettingController: UIViewController{
    
    var currentUserEmail: String = ""
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.image = UIImage(imageLiteralResourceName: "RepresentativeImage")
    
        return image
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임: "
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .darkGray
        textField.borderStyle = .line
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        return textField
    }()
    
    lazy var changeNickNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.tintColor = .systemBlue
//        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapChangeNickNameButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let commentChangeNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        return label
    }()
    @objc func tapChangeNickNameButton(_ sender: UIButton){
        guard let nickNameText = nickNameTextField.text else {return}
        if nickNameText.isEmpty {
            commentChangeNickNameLabel.text = "변경하실 닉네임을 작성해주세요"
            commentChangeNickNameLabel.textColor = .red
        }
        else if nickNameText.count > 10{
            commentChangeNickNameLabel.text = "닉네임은 10글자 이하여야합니다."
            commentChangeNickNameLabel.textColor = .red
        }else {
            Firestore.firestore().collection("user").document(currentUserEmail).updateData(["nickName":nickNameText])
            commentChangeNickNameLabel.text = "변경되었습니다."
            commentChangeNickNameLabel.textColor = .systemBlue
        }
    }
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayoutConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFireStoreUserData()
        setNavigationBar()
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        title = "프로필 관리"
        
    }
    
    func getFireStoreUserData(){
        Firestore.firestore().collection("user").document(currentUserEmail).getDocument{ document, err in
            if let err = err {
                print("GetFireStoreUserData Error: \(err.localizedDescription)")
            }
            else{
                let data = document?.data()
                guard let userEmail = data?["email"] as? String else {return}
                guard let userNickname = data?["nickName"] as? String else {return}
                
                self.nickNameTextField.text = userNickname
                self.emailLabel.text = "이메일:      " + userEmail
                
            }
        }
    }
    
    private func setLayoutConstraints(){
        view.addSubview(profileImage)
        view.addSubview(emailLabel)
        view.addSubview(nickNameLabel)
        view.addSubview(nickNameTextField)
        view.addSubview(changeNickNameButton)
        view.addSubview(commentChangeNickNameLabel)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nickNameTextField.translatesAutoresizingMaskIntoConstraints = false
        changeNickNameButton.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        commentChangeNickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.view.bounds.height / 8 ),
        profileImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        profileImage.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2),
        profileImage.heightAnchor.constraint(equalToConstant: self.view.bounds.width / 2),
        
        emailLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: 50),
        emailLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
        emailLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        
        nickNameLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor,constant: 20),
        nickNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
        nickNameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 8),
        
        nickNameTextField.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor),
        nickNameTextField.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 10),
        nickNameTextField.trailingAnchor.constraint(equalTo: changeNickNameButton.leadingAnchor, constant: -10),
        
        changeNickNameButton.centerYAnchor.constraint(equalTo: nickNameLabel.centerYAnchor),
        changeNickNameButton.heightAnchor.constraint(equalToConstant: 44),
        
        changeNickNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
        
        commentChangeNickNameLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 10),
        commentChangeNickNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
