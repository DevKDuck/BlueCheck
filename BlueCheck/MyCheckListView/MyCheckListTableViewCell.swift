//
//  MyCheckListTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/17.
//


import UIKit

class MyCheckListTableViewCell: UITableViewCell{
    var contentLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    
    var timeLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    

    
    private func setConstraint(){
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        contentView.backgroundColor = . white
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: self.timeLabel.trailingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -15)
            
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
