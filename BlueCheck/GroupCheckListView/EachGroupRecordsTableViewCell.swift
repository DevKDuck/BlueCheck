//
//  EachGroupRecordsTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class EachGroupRecordsTableViewCell: UITableViewCell{
    
    let writerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    
    private func setLayoutConstraints(){
        contentView.addSubview(writerNameLabel)
        contentView.addSubview(contentTitleLabel)
        
        contentView.backgroundColor = .white
        
        writerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            writerNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            writerNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            writerNameLabel.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width / 6),
            
            contentTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentTitleLabel.leadingAnchor.constraint(equalTo: self.writerNameLabel.trailingAnchor, constant: 20)
        
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


