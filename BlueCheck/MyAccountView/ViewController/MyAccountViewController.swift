//
//  MyAccountViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/31.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyAccountViewController: UIViewController{
    
    var currentUserEmail:String = ""
    
    let myAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    
    lazy var myAccountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nickNameLabel,emailLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyAccountTableViewCell.self, forCellReuseIdentifier: "MyAccountTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadingIndicator.showLoading()
        getFirebaseAuth()
        LoadingIndicator.hideLoading()
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBar()
        getFireStoreData()
        
    }
    
    func getFirebaseAuth(){
        let user = Auth.auth().currentUser
        if let user = user{
            currentUserEmail = user.email!
        }
    }
    
    func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        appearance.backgroundColor = .white

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        navigationItem.title = "더보기"
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        setLayoutConstraints()
    }
    
    func getFireStoreData(){
        let db = Firestore.firestore()
        db.collection("user").document(currentUserEmail).getDocument{ snapshot, error in
            if let err = error{
                print("MyAccountView Error:\(err.localizedDescription)")
            }
            else{
                let data = snapshot?.data()
                if let FirestoreData = data {
                    self.nickNameLabel.text = FirestoreData["nickName"] as? String
                    self.emailLabel.text = FirestoreData["email"] as? String
                }
            }
            
        }
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(myAccountView)
        self.view.addSubview(nickNameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(myAccountStackView)
        self.view.addSubview(tableView)
        
        myAccountView.translatesAutoresizingMaskIntoConstraints = false
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myAccountView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            myAccountView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            myAccountView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            myAccountView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3 - 50),
            
            myAccountStackView.centerXAnchor.constraint(equalTo: self.myAccountView.centerXAnchor),
            myAccountStackView.centerYAnchor.constraint(equalTo: self.myAccountView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.myAccountView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell") as?
                MyAccountTableViewCell else {return UITableViewCell()}
        
        let namingLabelArray = ["초대현황", "프로필 관리", "로그아웃", "회원탈퇴"]
        cell.namingLabel.text = namingLabelArray[indexPath.row]
        
        if indexPath.row == 2 || indexPath.row == 3{
            cell.namingLabel.textColor = .systemRed
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let invitationStatusViewController = InvitationStatusViewController()
            invitationStatusViewController.currentUserEmail = currentUserEmail
            self.navigationController?.pushViewController(invitationStatusViewController, animated: true)
        }
        if indexPath.row == 1 {
            let myProfileSettingController = MyProfileSettingController()
            myProfileSettingController.currentUserEmail = currentUserEmail
            self.navigationController?.pushViewController(myProfileSettingController, animated: true)
        }
        
        if indexPath.row == 2 {
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
            
            self.dismiss(animated: true)
            LogInViewController().modalPresentationStyle = .fullScreen
            self.present(LogInViewController(), animated: false)
        }
        
        if indexPath.row == 3 {
            let alert = UIAlertController(title: "회원탈퇴", message: "정말로 회원을 탈퇴하시겠습니까?", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "탈퇴", style: .default){[weak self]_ in
                let user = Auth.auth().currentUser
                
                user?.delete { error in
                    if let error = error{
                        print("Delete User Error: \(error.localizedDescription)")
                    }
                    else{
                        self?.dismiss(animated: true)
                        LogInViewController().modalPresentationStyle = .fullScreen
                        self?.present(LogInViewController(), animated: false)
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            present(alert, animated: false)
        }
    }
    
}
