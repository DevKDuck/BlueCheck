//
//  MyAccountTableViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class MyAccountTableViewCell: UITableViewCell {
    
    let namingLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private func setLayoutConstraints() {
        contentView.addSubview(namingLabel)
        contentView.backgroundColor = .white
        
        namingLabel.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            namingLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            namingLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayoutConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
