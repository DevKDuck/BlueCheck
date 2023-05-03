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
    
    private lazy var circleBG = UIView()
    
    lazy var haveScheduleCircle = UIView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var isSelected: Bool{
        willSet{
            if newValue{
                circleBG.layer.backgroundColor = UIColor.systemBlue.cgColor
                dayLabel.textColor = .white
            }
            else{
                circleBG.layer.backgroundColor = UIColor.clear.cgColor
                
                dayLabel.textColor = .darkGray
            }
        }
    }
    
    
    func configureDayLabel(text: String){
        self.addSubview(circleBG)
        self.addSubview(dayLabel)
        self.addSubview(haveScheduleCircle)
        
        haveScheduleCircle.frame = CGRect(x: (contentView.bounds.size.width / 2) - ((contentView.bounds.size.height / 8) / 2) , y:contentView.bounds.size.height - (contentView.bounds.size.height / 8) ,width: (contentView.bounds.size.height / 8), height: (contentView.bounds.size.height / 8))
        haveScheduleCircle.layer.cornerRadius = (contentView.bounds.size.height / 8) / 2
        
        
        circleBG.frame = CGRect(x: (contentView.bounds.size.width / 2) -  (contentView.bounds.size.height / 2) , y:0 ,width: contentView.bounds.size.height , height: contentView.bounds.size.height)
        circleBG.layer.cornerRadius = contentView.bounds.size.height / 2
        
        self.dayLabel.text = text
        self.dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
        self.dayLabel.textColor = .darkGray
        
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        haveScheduleCircle.layer.backgroundColor = UIColor.systemOrange.cgColor
        NSLayoutConstraint.activate([
            self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    

    func setSundayColor(){
        self.dayLabel.textColor = .systemBlue
    }
}
