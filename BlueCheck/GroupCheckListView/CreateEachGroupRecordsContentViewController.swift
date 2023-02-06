//
//  CreateEachGroupRecordsContentViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit

class CreateEachGroupRecordsContentViewController: UIViewController{
    
    
    let topView: UIView = {
        let topview = UIView()
        topview.backgroundColor = .white
        return topview
    }()
    
    //MARK: 임시 뒤로가기 버튼
    lazy var disMissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var completeButton : UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapDismissButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 작성해보세요"
        textField.backgroundColor = .white
        textField.textColor = .darkGray
        
        return textField
    }()
    
    let dateButton : UIButton = {
        let button = UIButton()
        button.setTitle("날짜", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    let recordImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
//    let barView: UIView = {
//        let barview = UIView()
//        barview.backgroundColor = .darkGray
//        return barview
//    }()
    
    
//    lazy var titleStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [titleTextField,barView])
//        stackView.axis = .vertical
//        stackView.spacing = 3
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    lazy var dateStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [dateButton,barView])
//        stackView.axis = .vertical
//        stackView.spacing = 3
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    lazy var recordImageStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [recordImage,barView])
//        stackView.axis = .vertical
//        stackView.spacing = 3
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    
    var contentTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .white
        textView.textInputView.backgroundColor = .white
        textView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.scrollIndicatorInsets = .init(top: 10, left: 10, bottom: 10, right: 20)
        textView.textColor = .darkGray
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayoutConstraints()
    }
    
    private func setLayoutConstraints(){
        self.view.addSubview(topView)
        self.view.addSubview(completeButton)
        self.view.addSubview(disMissButton)
        self.view.addSubview(titleTextField)
        self.view.addSubview(dateButton)
        self.view.addSubview(recordImage)
        self.view.addSubview(contentTextView)
        
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        disMissButton.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        recordImage.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 44),
            
            completeButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor,constant: -20),
            
            disMissButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            disMissButton.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 5),
            titleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            dateButton.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 5),
            dateButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            dateButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            dateButton.heightAnchor.constraint(equalToConstant: 50),
            
            recordImage.topAnchor.constraint(equalTo: self.dateButton.bottomAnchor, constant: 5),
            recordImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recordImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recordImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            
            contentTextView.topAnchor.constraint(equalTo: self.recordImage.bottomAnchor,constant: 5),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
    }
}
