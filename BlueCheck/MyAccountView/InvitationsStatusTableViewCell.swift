//
//  InvitationsStatusTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class InvitationsStatusTableViewCell: UITableViewCell{
    
    let objectiveLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        return label
    }()

    let groupNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        return label
    }()

    
    let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitle("수락", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("거절", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var acceptAndRejectButtonStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [acceptButton,rejectButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setLayoutConstraints() {
        contentView.addSubview(objectiveLabel)
        contentView.addSubview(groupNameLabel)
        contentView.addSubview(acceptAndRejectButtonStackView)
        
        
        objectiveLabel.translatesAutoresizingMaskIntoConstraints = false
        groupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
        
            objectiveLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            objectiveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            objectiveLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 6),
            
            groupNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.objectiveLabel.trailingAnchor, constant: 10),
            groupNameLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 2),
            
            acceptAndRejectButtonStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acceptAndRejectButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            groupNameLabel.trailingAnchor.constraint(equalTo: self.acceptAndRejectButtonStackView.leadingAnchor, constant: -10)

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
