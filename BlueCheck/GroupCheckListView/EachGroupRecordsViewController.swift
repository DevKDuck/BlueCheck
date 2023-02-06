//
//  EachGroupRecordsViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class EachGroupRecordsViewController: UIViewController {
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    let groupListLabel : UILabel = {
        let label = UILabel()
        label.text = "그룹명"
        label.textColor = .systemBlue
        return label
    }()
    
    lazy var addContentButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapAddContentButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapAddContentButton(_ sender: UIButton){

        let goVC = CreateEachGroupRecordsContentViewController()
        goVC.modalPresentationStyle = .fullScreen
        self.present(goVC,animated: true, completion: nil)
    }
    
    
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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EachGroupRecordsTableViewCell.self, forCellReuseIdentifier: "EachGroupRecordsTableViewCell")
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
        self.view.addSubview(dismissButton)
        self.view.addSubview(addContentButton)
        self.view.addSubview(tableView)
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        groupListLabel.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        addContentButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            groupListLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            groupListLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            
            dismissButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 20),
            
            addContentButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addContentButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -15),
            
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
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
