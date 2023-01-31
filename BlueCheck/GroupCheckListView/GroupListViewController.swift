//
//  GroupListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit


class GroupListViewController: UIViewController{
    
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
        guard let goCreateGroupViewController = storyboard?.instantiateViewController(withIdentifier: "CreateGoupViewController") as? CreateGoupViewController else {return}
        
        self.present(goCreateGroupViewController,animated: true, completion: nil)
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GroupListTableViewCell.self, forCellReuseIdentifier: "GroupListTableViewCell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListTableViewCell", for: indexPath) as? GroupListTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = "그룹명"
        cell.objectGroupImage.image = UIImage(systemName: "squareshape")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
