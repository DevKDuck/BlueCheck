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
    
    var currentUser: User?
    
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
        goCreateGroupViewController.currentUser = self.currentUser
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    func getFireStoreData() {
        Firestore.firestore().collection("user").document(self.currentUser?.uid ?? "ㅇㅇ").collection("group").getDocuments { querySnapshot, error in
            for document in querySnapshot!.documents{
                print(document.documentID)
                print(document.data())
                let data = document.data()
                guard let groupName = data["그룹명"] as? String else {return}
                guard let groupObject = data["목표"] as? String else {return}
                
                self.groupNameArray.append(groupName)
                self.groupDocumentsArray.append(document.documentID)
                
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
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        getFireStoreData()
        setAutolayoutConstraint()
    }
    
    
    private func setAutolayoutConstraint(){
        
        self.view.addSubview(topView)
        self.view.addSubview(groupListLabel)
        //        self.view.addSubview(gologInRequestButton) //임시 로그인
        self.view.addSubview(addGroupButton)
        self.view.addSubview(tableView)
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        groupListLabel.translatesAutoresizingMaskIntoConstraints = false
        //        gologInRequestButton.translatesAutoresizingMaskIntoConstraints = false //임시 로그인
        addGroupButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            
            //MARK: 임시로그인
            //            gologInRequestButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            //            gologInRequestButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 20),
            //
            
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goEachGroupRecordsViewController = EachGroupRecordsViewController()
        goEachGroupRecordsViewController.modalPresentationStyle = .fullScreen
        goEachGroupRecordsViewController.currentUser = self.currentUser
        goEachGroupRecordsViewController.groupDocumentName = self.groupDocumentsArray[indexPath.row]
        
        self.navigationController?.pushViewController(goEachGroupRecordsViewController, animated: true)
    }
}
