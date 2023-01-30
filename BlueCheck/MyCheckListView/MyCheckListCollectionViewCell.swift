//
//  MyCheckListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/13.
//

import UIKit

class MyCheckListCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "MyCheckListCollectionViewCell"
    
    
    var collectionViewCellTaskArray : [MyCheckListTask]?
    
    
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var isSelected: Bool{
        willSet{
            if newValue{
                self.backgroundColor = .systemBlue
                dayLabel.textColor = .white
            }
            else{
                self.backgroundColor = .clear
                dayLabel.textColor = .darkGray
            }
        }
    }
    
    
    func configureDayLabel(text: String){
        self.addSubview(dayLabel)
        self.dayLabel.text = text
        self.dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
        self.dayLabel.textColor = .darkGray
        
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    

    func setSundayColor(){
        self.dayLabel.textColor = .systemBlue
    }
}
