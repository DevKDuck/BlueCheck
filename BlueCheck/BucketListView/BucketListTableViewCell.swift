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
        label.textColor = UIColor.gray
        return label
    }()
    
    var checkOrNoCheck = true
    
    lazy var checkButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "squareshape"), for: .normal)
        button.addTarget(self, action: #selector(pressCheckButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func pressCheckButton(_ sender: UITapGestureRecognizer){
        if checkOrNoCheck == true {
            checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            checkOrNoCheck = false
            contentView.backgroundColor = UIColor(hue: 0.5611, saturation: 0.47, brightness: 0.91, alpha: 1.0)
        }
        else{
            checkButton.setImage(UIImage(systemName: "squareshape"), for: .normal)
            checkOrNoCheck = true
            contentView.backgroundColor = .white
        }
    }
    
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
    }//??????????????? ????????? ???????????? ?????? ???????????? ???????????????
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
}
