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
    
    var inviteGroupList: [InviteListTask] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InvitationsStatusTableViewCell.self, forCellReuseIdentifier: "InvitationsStatusTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        title = "초대현황"
        
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
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
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
        
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Group").document(inviteGroupList[sender.tag].groupNumber).setData(data){ error in
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
