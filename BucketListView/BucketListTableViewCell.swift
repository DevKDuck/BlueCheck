//
//  BucketListTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

class BucketListTableViewCell: UITableViewCell{
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "버킷리스트1"
        label.textColor = UIColor.gray
        return label
    }()
    
    private func setConstraint(){
        contentView.addSubview(label)
        contentView.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setConstraint()
    }//인터페이스 빌더를 사용하지 않아 초기화를 해주어야함

        

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }
}
