//
//  MyCheckListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/13.
//

import UIKit

class MyCheckListCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "MyCheckListCollectionViewCell"
    
    //MARK: components 전달받음
    var components = DateComponents()
    lazy var objectKey: String = "\(components.year!)년 \(components.month!)월 \(dayLabel.text!)일"
    
    
    //MARK: 여기
    //private 작성했었음
     lazy var dayLabel = UILabel()
    
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
                
                print(objectKey)
                
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
