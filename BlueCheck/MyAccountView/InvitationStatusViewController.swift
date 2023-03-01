//
//  InvitationStatusViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit
import Firebase
import FirebaseFirestore

class InvitationStatusViewController: UIViewController{
    
    var currentUserEmail: String = ""
//    var invitedGroupNameArray = [String]()
//    var invitedObjectArray = [String]()
//    var inviteGroupNumberArray = [String]()
//    var inviteGroupContentArray = [String]()
    
    var inviteGroupList: [InviteListTask] = []
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    let invitationStatusLabel : UILabel = {
        let label = UILabel()
        label.text = "초대 현황"
        label.textColor = .systemBlue
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InvitationsStatusTableViewCell.self, forCellReuseIdentifier: "InvitationsStatusTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    
    //MARK: 임시 뒤로가기 버튼
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapDismissButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setLayoutConstraints()
        getFirebaseGroupInvitationStatus()
    }
    
    func getFirebaseGroupInvitationStatus(){
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Invite status").getDocuments{ documents, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            else{
                self.inviteGroupList.removeAll()
                guard let documents = documents else {return}
                for document in documents.documents{
                    
                    do{
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let inviteList = try JSONDecoder().decode(InviteListTask.self, from: jsonData)
                        self.inviteGroupList.append(inviteList)
                    }
                    catch let err{
                        print("err: \(err)")
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(topView)
        self.view.addSubview(invitationStatusLabel)
        self.view.addSubview(dismissButton)
        self.view.addSubview(tableView)
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        invitationStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            invitationStatusLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            invitationStatusLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            dismissButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension InvitationStatusViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteGroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationsStatusTableViewCell") as? InvitationsStatusTableViewCell else {return UITableViewCell()}
        cell.groupNameLabel.text = inviteGroupList[indexPath.row].groupName
        cell.objectiveLabel.text = inviteGroupList[indexPath.row].object
        
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(tapAcceptButton(_:)), for: .touchUpInside)
        cell.rejectButton.tag = indexPath.row
        cell.rejectButton.addTarget(self, action: #selector(tapRejectButton(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func tapAcceptButton (_ sender: UIButton){
        //자신의 groupList에 추가
        let data = ["groupName" : inviteGroupList[sender.tag].groupName, "groupNumber" :inviteGroupList[sender.tag].groupNumber,"object" :inviteGroupList[sender.tag].object, "content" : inviteGroupList[sender.tag].content]
        
        Firestore.firestore().collection("user").document(currentUserEmail).collection("group").document(inviteGroupList[sender.tag].groupNumber).setData(data){ error in
            if let error = error{
                print("Error:\(error.localizedDescription)")
                return
            }
        }
        
        //Invite Status의 document 삭제
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Invite status").document(inviteGroupList[sender.tag].groupNumber).delete(){ err in
            if let err = err{
                print("Error removing document: \(err)")
            }
            else{
                print("Document successfully removed!")
            }
        }
        
        let alert = UIAlertController(title: "초대에 수락하였습니다", message: "그룹리스트를 확인해보세요", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .cancel){ _ in
            self.getFirebaseGroupInvitationStatus()
        }
        alert.addAction(confirm)
        self.present(alert, animated: false)
    }
    
    @objc func tapRejectButton (_ sender: UIButton){
        
        //Invite Status의 document 삭제
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Invite status").document(inviteGroupList[sender.tag].groupNumber).delete(){ err in
            if let err = err{
                print("Error removing document: \(err)")
            }
            else{
                print("Document successfully removed!")
            }
        }
        
        let alert = UIAlertController(title: "초대를 거절하였습니다", message: "", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .cancel){ _ in
            self.getFirebaseGroupInvitationStatus()
        }
        alert.addAction(confirm)
        self.present(alert, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let invitationGroupContentView = InvitationGroupContentViewController()
        invitationGroupContentView.modalPresentationStyle = .popover
        invitationGroupContentView.titleLabel.text = "그룹명: " + inviteGroupList[indexPath.row].groupName
        invitationGroupContentView.objectLabel.text = "목적: " + inviteGroupList[indexPath.row].object
        invitationGroupContentView.contentLabel.text = "자세한 내용 : " + inviteGroupList[indexPath.row].content
        
        
        present(invitationGroupContentView, animated: true)
    }
    
}
