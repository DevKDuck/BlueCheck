//
//  GroupListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/22.
//

import UIKit

class GroupListCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "GroupListCollectionViewCell"
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let writerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let endDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "square")
        imageView.backgroundColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setLayoutConstraints(){
        self.addSubview(titleLabel)
        self.addSubview(writerLabel)
        self.addSubview(authImage)
        self.addSubview(startDateLabel)
        self.addSubview(endDateLabel)
        self.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            
            writerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            writerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            authImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 10),
            authImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            authImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            authImage.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
            
            
            startDateLabel.topAnchor.constraint(equalTo: self.authImage.bottomAnchor, constant: 10),
            startDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            
            endDateLabel.topAnchor.constraint(equalTo: self.startDateLabel.bottomAnchor, constant: 10),
            endDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            contentLabel.topAnchor.constraint(equalTo: self.endDateLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
        ])
        
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
            
    }
}
