//
//  GroupListTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/31.
//

import UIKit

class GroupListTableViewCell: UITableViewCell{
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 1
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let objectGroupImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    private func setLayoutConstraint(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(objectGroupImage)
        contentView.addSubview(contentLabel)
        
        contentView.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        objectGroupImage.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            objectGroupImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            objectGroupImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            objectGroupImage.heightAnchor.constraint(equalToConstant: 50),
            objectGroupImage.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.objectGroupImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: self.objectGroupImage.trailingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayoutConstraint()
    }//인터페이스 빌더를 사용하지 않아 초기화를 해주어야함
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
