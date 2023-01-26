//
//  MyCheckListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/01/13.
//

import UIKit

class MyCheckListCollectionViewCell: UICollectionViewCell{
    
    weak var delegate: DelegateCell?
    static let identifier = "MyCheckListCollectionViewCell"
    
    //MARK: components 전달받음
    var components = DateComponents()
    lazy var objectKey: String = "\(components.year!)년 \(components.month!)월 \(dayLabel.text!)일"
    
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
                if let reloadData = self.delegate?.delegateCell(){
                    reloadData
                }
                
                var objectKey2: String = "\(components.year!)년 \(components.month!)월 \(dayLabel.text!)일"
                if let savedData = UserDefaults.standard.object(forKey: objectKey2) as? Data{
                    let decoder = JSONDecoder()
                    
                    do{
                        let saveObject = try decoder.decode([MyCheckListTask].self, from:savedData)
                        if saveObject.isEmpty{
                            
                        }
                        else{
                            collectionViewCellTaskArray = saveObject
                        }
                    }
                    catch{
                        print("This day \(objectKey2) have no UserDefaultData")
                    }
                }
                else{
                    collectionViewCellTaskArray = [MyCheckListTask(title: "안녕하세요", content: "네네", importance: "중요")]
                    print("없음")
                }
                
                self.backgroundColor = .systemBlue
                dayLabel.textColor = .white
                /*
                 UserDefault를 objectKey 값으로 받아 와야함
                 */
                
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
