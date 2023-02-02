//
//  InviteListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/01.
//

import UIKit

class InviteListViewController: UIViewController{
    
    
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
    
    
    lazy var addPersonnelButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapAddPersonnelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAddPersonnelButton(_ sender: UIButton){
        guard let goInvitePersonalInformationViewController = storyboard?.instantiateViewController(withIdentifier: "InvitePersonalInformationViewController") as? InvitePersonalInformationViewController else {return}
        goInvitePersonalInformationViewController.modalPresentationStyle = .fullScreen
        
        self.present(goInvitePersonalInformationViewController,animated: true, completion: nil)
    }
    
    
    lazy var completeAddPersonnelButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapCompleteAddPersonnelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapCompleteAddPersonnelButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(InviteListTableViewCell.self, forCellReuseIdentifier: "InviteListTableViewCell")
        return tableView
    }()
    
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
        
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        invitePersonnelLabel.translatesAutoresizingMaskIntoConstraints = false
        addPersonnelButton.translatesAutoresizingMaskIntoConstraints = false
        completeAddPersonnelButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
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
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

extension InviteListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteListTableViewCell") as? InviteListTableViewCell else {return UITableViewCell()}
        
        cell.nameLabel.text = "경덕"
        cell.emailLabel.text = "loading95@naver.com"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
