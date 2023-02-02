//
//  InviteListTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/02.
//

import UIKit

class InviteListTableViewCell: UITableViewCell{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        return button
    }()
    
    
    private func setLayoutConstraints(){
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(removeButton)
        
        contentView.backgroundColor = .white
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: self.removeButton.leadingAnchor, constant: -20)

        
        ])
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayoutConstraints()
    }//인터페이스 빌더를 사용하지 않아 초기화를 해주어야함
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
