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
    
    var currentUser: User?
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    let seeMoreLabel : UILabel = {
        let label = UILabel()
        label.text = "더보기"
        label.textColor = .systemBlue
        return label
    }()
    
    let myAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    let nameLabel: UILabel = {
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
        let stackView = UIStackView(arrangedSubviews: [nameLabel,emailLabel])
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
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        setLayoutConstraints()
        getFireStoreData()
    }
    
    func getFireStoreData(){
        let db = Firestore.firestore()
        
        db.collection("user").document(self.currentUser?.uid ?? "ㅇㅇ").getDocument{ snapshot, error in
            if let err = error{
                print("MyAccountView Error:\(err.localizedDescription)")
            }
            else{
                let data = snapshot?.data()
                if let FirestoreData = data {
                    self.nameLabel.text = FirestoreData["name"] as? String
                    self.emailLabel.text = FirestoreData["email"] as? String
                }
            }
            
        }
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(topView)
        self.view.addSubview(seeMoreLabel)
        self.view.addSubview(myAccountView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(myAccountStackView)
        self.view.addSubview(tableView)
        
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        seeMoreLabel.translatesAutoresizingMaskIntoConstraints = false
        myAccountView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            seeMoreLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            seeMoreLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            myAccountView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountTableViewCell") as?
                MyAccountTableViewCell else {return UITableViewCell()}
        
        let namingLabelArray = ["초대현황", "그룹 관리", "로그아웃"]
        cell.namingLabel.text = namingLabelArray[indexPath.row]
        
        if indexPath.row == 2{
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
            invitationStatusViewController.modalPresentationStyle = .fullScreen
            self.present(invitationStatusViewController, animated: true)
        }
        
        if indexPath.row == 2 {
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "pw")
            self.dismiss(animated: true)
        }
    }
    
}
