//
//  GroupListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class GroupListViewController: UIViewController{
    
    var currentUserEmail: String = ""
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    let groupListLabel : UILabel = {
        let label = UILabel()
        label.text = "그룹 리스트"
        label.textColor = .systemBlue
        return label
    }()
    
    lazy var addGroupButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapAddGroupButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAddGroupButton(_ sender: UIButton){
        let goCreateGroupViewController = CreateGroupViewController()
        goCreateGroupViewController.modalPresentationStyle = .fullScreen
        goCreateGroupViewController.currentUserEmail = self.currentUserEmail
        
        self.present(goCreateGroupViewController,animated: true, completion: nil)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GroupListTableViewCell.self, forCellReuseIdentifier: "GroupListTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var groupNameArray = [String]()
    var groupObjectArray = [UIImage]()
    var groupDocumentsArray = [String]()
    var groupContentArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFirebaseAuth()
        self.navigationController?.navigationBar.isHidden = true
        groupNameArray.removeAll()
        groupDocumentsArray.removeAll()
        groupContentArray.removeAll()
        getFireStoreData()
        
    }
    
    func getFirebaseAuth(){
        let user = Auth.auth().currentUser
        if let user = user{
            currentUserEmail = user.email!
        }
    }
    
    
    func getFireStoreData() {
        LoadingIndicator.showLoading()
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Group").getDocuments { querySnapshot, error in
            
            guard let querySnapshot = querySnapshot else {return}
            for document in querySnapshot.documents{
                let data = document.data()
                guard let groupName = data["groupName"] as? String else {return}
                guard let groupObject = data["object"] as? String else {return}
                guard let groupContent = data["content"] as? String else {return}
                
                
                self.groupNameArray.append(groupName)
                self.groupDocumentsArray.append(document.documentID)
                self.groupContentArray.append(groupContent)
                
                switch groupObject{
                case "공부":
                    self.groupObjectArray.append(UIImage(systemName: "book")!)
                case "운동":
                    self.groupObjectArray.append(UIImage(systemName: "figure.strengthtraining.traditional")!)
                case "여행":
                    self.groupObjectArray.append(UIImage(systemName: "figure.stairs")!)
                case "맛집":
                    self.groupObjectArray.append(UIImage(systemName: "light.recessed")!)
                case "기타":
                    self.groupObjectArray.append(UIImage(systemName: "guitars")!)
                default:
                    break
                }
                
            }
            LoadingIndicator.hideLoading()
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setAutolayoutConstraint()
    }

    private func setAutolayoutConstraint(){
        
        self.view.addSubview(topView)
        self.view.addSubview(groupListLabel)
        self.view.addSubview(addGroupButton)
        self.view.addSubview(tableView)

        topView.translatesAutoresizingMaskIntoConstraints = false
        groupListLabel.translatesAutoresizingMaskIntoConstraints = false
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            groupListLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            groupListLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            addGroupButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addGroupButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -15),
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListTableViewCell", for: indexPath) as? GroupListTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = groupNameArray[indexPath.row]
        cell.objectGroupImage.image = groupObjectArray[indexPath.row]
        cell.contentLabel.text = groupContentArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goGroupListCollectionViewController = EachGroupRecordsViewController()
        goGroupListCollectionViewController.modalPresentationStyle = .fullScreen
        goGroupListCollectionViewController.currentUserEmail = self.currentUserEmail
        goGroupListCollectionViewController.groupDocumentName = self.groupDocumentsArray[indexPath.row]
        
        self.navigationController?.pushViewController(goGroupListCollectionViewController, animated: true)
    }
}
