//
//  InvitationGroupContentViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/28.
//

import UIKit

class InvitationGroupContentViewController: UIViewController{
    
    
    let centerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.layer.cornerRadius = 10
        return uiView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    let objectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textColor = .darkGray
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(centerView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(objectLabel)
        self.view.addSubview(contentLabel)
        
        centerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        objectLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 10),
            centerView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            centerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            centerView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 15),
            
            objectLabel.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 15),
            objectLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            contentLabel.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: -10)
            
            
        
        ])
        
        
        
    }
    
}
