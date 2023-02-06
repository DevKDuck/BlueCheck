//
//  InvitationStatusViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class InvitationStatusViewController: UIViewController{
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationsStatusTableViewCell") as? InvitationsStatusTableViewCell else {return UITableViewCell()}
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    
}
