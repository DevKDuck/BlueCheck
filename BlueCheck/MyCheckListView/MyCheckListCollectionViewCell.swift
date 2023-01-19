//
//  MyCheckListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/13.
//

import UIKit

class MyCheckListCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "MyCheckListCollectionViewCell"
    
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func configureDayLabel(text: String){
        self.addSubview(dayLabel)
        self.dayLabel.text = text
        self.dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
        self.dayLabel.textColor = .darkGray
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self.dayLabel, action: #selector(changeLabel(_:)))
//        self.dayLabel.addGestureRecognizer(tapGestureRecognizer)
//
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
//    @objc func changeLabel(_ sender: UILabel){
//        self.dayLabel.textColor = .systemBlue
//    }
//    
    func setSundayColor(){
        self.dayLabel.textColor = .systemBlue
    }
}
