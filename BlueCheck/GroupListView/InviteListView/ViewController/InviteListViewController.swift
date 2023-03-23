//
//  InviteListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/01.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol GettingInvitationList: AnyObject{
    func getUserNameArray(nameArray:[String])
    func getUserEmailArray(emailArray:[String])
    func getEmailAfterTableViewReload()
}


class InviteListViewController: UIViewController, GettingInvitationList{
    
    func getUserNameArray(nameArray: [String]) {
        userNameArray = nameArray
    }
    
    func getUserEmailArray(emailArray: [String]) {
        userEmailArray = emailArray
    }
    
    func getEmailAfterTableViewReload() {
        tableView.reloadData()
    }
    

    
    var userUidArray = [String]()
    var userNameArray = [String]()
    var userEmailArray = [String]()
    weak var inviteDatadelegate: GetInvitationList?
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    let invitePersonnelLabel : UILabel = {
        let label = UILabel()
        label.text = "인원 초대"
        label.textColor = .systemBlue
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = { // indicator가 사용될 때까지 인스턴스를 생성하지 않도록 lazy로 선언
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.splitViewController?.view.center ?? CGPoint() // indicator의 위치 설정
        activityIndicator.style = UIActivityIndicatorView.Style.large // indicator의 스타일 설정, large와 medium이 있음
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var addPersonnelButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapAddPersonnelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAddPersonnelButton(_ sender: UIButton){
//        let alert = UIAlertController(title: "이메일", message: "초대하고 싶은 사람의 이메일을 적어보세요", preferredStyle: .alert)
//        let add = UIAlertAction(title: "추가", style: .default){ [weak self] _ in
//            DispatchQueue.global().async {
//                Firestore.firestore().collection("user").getDocuments{ querySnapshot, error in
//                    for document in querySnapshot!.documents{
//                        let data = document.data()
//                        guard let userEmail = data["email"] as? String else {return}
//                        if let text = alert.textFields?[0].text{
//                            if text == userEmail{
//                                //guard let userName = data["name"] as? String else { return }
//                                guard let userUID = data["uid"] as? String else { return }
//                                self?.userUidArray.append(userUID)
//                            }
//                        }
//
//                    }
//
//                }
//            }
//            self?.activityIndicator.startAnimating()
//            self?.activityIndicator.isHidden = false
//
//                self?.tableView.reloadData()
//
//        }
//
//        let cancel = UIAlertAction(title: "취소", style: .cancel){ _ in
//
//        }
//
//        alert.addTextField{ textField in
//            textField.placeholder = "이메일을 적어보세요"
//            textField.textColor = .systemBlue
//        }
//
//        alert.addAction(add)
//        alert.addAction(cancel)
//
//        present(alert, animated: true)
       let vc = InvitePersonalInformationViewController()
        vc.delegate = self
        vc.userEmailArray = userEmailArray
        vc.userNameArray = userNameArray
        self.present(vc, animated: true)
    }
    
    
    lazy var completeAddPersonnelButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapCompleteAddPersonnelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapCompleteAddPersonnelButton(_ sender: UIButton){
       
        if let nameData = self.inviteDatadelegate?.getUserNameArray(nameArray: userNameArray){
            nameData
        }
        if let emailData = self.inviteDatadelegate?.getUserEmailArray(emailArray: userEmailArray){
            emailData
        }
        
        self.dismiss(animated: true)
    }
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InviteListTableViewCell.self, forCellReuseIdentifier: "InviteListTableViewCell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserNameArray(nameArray: userNameArray)
        getUserEmailArray(emailArray: userEmailArray)
        getEmailAfterTableViewReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        setLayoutConstraints()
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(topView)
        self.view.addSubview(invitePersonnelLabel)
        self.view.addSubview(addPersonnelButton)
        self.view.addSubview(completeAddPersonnelButton)
        self.view.addSubview(tableView)
        self.view.addSubview(activityIndicator)
        
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        invitePersonnelLabel.translatesAutoresizingMaskIntoConstraints = false
        addPersonnelButton.translatesAutoresizingMaskIntoConstraints = false
        completeAddPersonnelButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            invitePersonnelLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            invitePersonnelLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            
            addPersonnelButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addPersonnelButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -15),
            
            completeAddPersonnelButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            completeAddPersonnelButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 15),
            
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
    }
}

extension InviteListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if userUidArray.isEmpty{
//            return 0
//        }
//        else{
//            return userUidArray.count
//        }
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteListTableViewCell") as? InviteListTableViewCell else {return UITableViewCell()}
        
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.nameLabel.text = userNameArray[indexPath.row]
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(tapRemoveButton( _:)), for: .touchUpInside)
        
//        if !userUidArray.isEmpty{
//
//            DispatchQueue.global().async {
//                Firestore.firestore().collection("user").document(self.userUidArray[indexPath.row]).getDocument{ snapshot, error in
//                    if let error = error{
//                        print(error,"왜안돼")
//                    }
//                    else{
//                        print(self.userUidArray)
//                        let data = snapshot?.data()
//
//                        DispatchQueue.main.async {
//                            self.activityIndicator.stopAnimating()
//                            self.activityIndicator.isHidden = true
//                            cell.nameLabel.text = data?["name"] as? String
//                            cell.emailLabel.text = data?["email"] as? String
//                        }
//                    }
//                }
//            }
//        }
        
        return cell
    }
    
    @objc func tapRemoveButton(_ sender: UIButton){
    
        
        let alert = UIAlertController(title: "\(userNameArray[sender.tag]) 님", message: "\(userNameArray[sender.tag]) 님을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제", style: .default){ _ in
            self.userNameArray.remove(at: sender.tag)
            self.userEmailArray.remove(at: sender.tag)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
