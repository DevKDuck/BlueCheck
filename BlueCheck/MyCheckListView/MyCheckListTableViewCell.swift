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
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    var importLabel: UILabel = {
        var label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    var checkOrNoCheck = true
    
    
    lazy var checkButton: UIButton = {
        var button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
        button.setImage(UIImage(systemName: "squareshape", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapRemoveButton(_:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc func tapRemoveButton(_ sender: UITapGestureRecognizer){
        if checkOrNoCheck == true {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
            checkButton.setImage(UIImage(systemName: "checkmark.square",withConfiguration: imageConfig), for: .normal)
            checkOrNoCheck = false
            contentView.backgroundColor = .systemBlue
            contentLabel.textColor = .white
            importLabel.textColor = .black
            checkButton.tintColor = .white
        }
        else{
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
            checkButton.setImage(UIImage(systemName: "squareshape", withConfiguration: imageConfig), for: .normal)
            checkOrNoCheck = true
            contentView.backgroundColor = .white
            contentLabel.textColor = .darkGray
            importLabel.textColor = .darkGray
            checkButton.tintColor = .systemBlue
        }
    }
    
    
    private func setConstraint(){
        contentView.addSubview(importLabel)
        contentView.addSubview(checkButton)
        contentView.addSubview(contentLabel)
        contentView.backgroundColor = . white
        
        importLabel.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        

        
        NSLayoutConstraint.activate([
            importLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            importLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            importLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 5),
            
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            checkButton.widthAnchor.constraint(equalToConstant: 44),
            checkButton.heightAnchor.constraint(equalToConstant: 44),
            
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: self.importLabel.trailingAnchor, constant: 15),
            contentLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 50 - (contentView.bounds.width / 5))
//            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -55)
            
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
