//
//  BucketListTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

class BucketListTableViewCell: UITableViewCell{
    
    var label: UILabel = {
        var label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont(name: "Maplestory OTF Bold.otf", size: 14)
        return label
    }()
    
    
    lazy var checkButton: UIButton = {
        var button = UIButton()
        return button
    }()
    
    private func setConstraint(){
        contentView.addSubview(label)
        contentView.addSubview(checkButton)
        contentView.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            checkButton.widthAnchor.constraint(equalToConstant: 44)
            
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
