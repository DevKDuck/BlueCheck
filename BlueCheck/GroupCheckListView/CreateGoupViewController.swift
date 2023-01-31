//
//  CreateGoupViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/31.
//

import UIKit

class CreateGoupViewController: UIViewController{
    
    let groupTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "그룹명"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let groupTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "그룹명을 작성해주세요."
        return textField
    }()
    
    let groupObjectiveLabel : UILabel = {
        let label = UILabel()
        label.text = "목표"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    
    let studyLabel: UILabel = {
        let label = UILabel()
        label.text = "공부"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let studyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "book")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let studyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "운동"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let exerciseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.strengthtraining.traditional")
        return imageView
    }()
    
    let exerciseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let travelLabel: UILabel = {
        let label = UILabel()
        label.text = "여행"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let travelImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.stairs")
        return imageView
    }()
    
    let travelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let restaurantLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let restaurantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "light.recessed")
        return imageView
    }()
    
    let restaurantStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let etcLabel: UILabel = {
        let label = UILabel()
        label.text = "기타"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let etcImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "guitars")
        return imageView
    }()
    
    let etcStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let objectiveStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutConstraints()
        self.view.backgroundColor = .white
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(groupTitleLabel)
        self.view.addSubview(groupTitleTextField)
        self.view.addSubview(groupObjectiveLabel)
        self.view.addSubview(self.studyStackView)
        self.view.addSubview(self.exerciseStackView)
        self.view.addSubview(self.travelStackView)
        self.view.addSubview(self.restaurantStackView)
        self.view.addSubview(self.etcStackView)
        self.view.addSubview(self.objectiveStackView)
        
        
        NSLayoutConstraint.activate([
            groupTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            groupTitleTextField.topAnchor.constraint(equalTo: self.groupTitleLabel.bottomAnchor, constant: 20),
            groupTitleTextField.leadingAnchor.constraint(equalTo: self.groupTitleLabel.leadingAnchor, constant: 20),
            
            groupObjectiveLabel.topAnchor.constraint(equalTo: self.groupTitleTextField.bottomAnchor, constant: 20),
            groupObjectiveLabel.leadingAnchor.constraint(equalTo: self.groupTitleTextField.leadingAnchor, constant: 20),
            
            objectiveStackView.topAnchor.constraint(equalTo: self.groupObjectiveLabel.bottomAnchor, constant: 20),
            objectiveStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            objectiveStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        [studyImage, studyLabel].map{
            self.studyStackView.addArrangedSubview($0)
        }
        
        [exerciseImage, exerciseLabel].map{
            self.exerciseStackView.addArrangedSubview($0)
        }
        
        [travelImage, travelLabel].map{
            self.travelStackView.addArrangedSubview($0)
        }
        
        [restaurantImage, restaurantLabel].map{
            self.restaurantStackView.addArrangedSubview($0)
        }
        
        [etcImage, etcLabel].map{
            self.etcStackView.addArrangedSubview($0)
        }
        
        [studyStackView,exerciseStackView,travelStackView,restaurantStackView,etcStackView].map{
            self.objectiveStackView.addArrangedSubview($0)
        }
        
    }
    
    
}
