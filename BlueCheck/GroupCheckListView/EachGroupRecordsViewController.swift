//
//  EachGroupRecordsViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EachGroupRecordsViewController: UIViewController {
    
    var currentUserEmail: String = ""
    var groupDocumentName = ""
    
    lazy var addContentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(tapAddContentButton(_:)))
        return button
    }()
    
    @objc func tapAddContentButton(_ sender: UIButton){

        let goVC = CreateEachGroupRecordsContentViewController()
        goVC.currentUserEmail = self.currentUserEmail
        goVC.groupDocumentName = self.groupDocumentName
        
        goVC.modalPresentationStyle = .fullScreen
//        self.present(goVC,animated: true, completion: nil)
        self.navigationController?.pushViewController(goVC, animated: true)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EachGroupRecordsTableViewCell.self, forCellReuseIdentifier: "EachGroupRecordsTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "그룹명"
        self.navigationItem.rightBarButtonItem = self.addContentButton
        getFireStoreData()
        setAutolayoutConstraint()
    }
    
    func getFireStoreData() {
        Firestore.firestore().collection(groupDocumentName).document(currentUserEmail).collection("Group").getDocuments { querySnapshot, error in
            for document in querySnapshot!.documents{
                let data = document.data()
                print(data)
            }
            self.tableView.reloadData()
        }
    }
    
    
    private func setAutolayoutConstraint(){
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

extension EachGroupRecordsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EachGroupRecordsTableViewCell", for: indexPath) as? EachGroupRecordsTableViewCell else { return UITableViewCell()}
        
        cell.writerNameLabel.text = "[경덕]"
        cell.contentTitleLabel.text = "등운동"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
