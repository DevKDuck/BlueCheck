//
//  MyCheckListSettingViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/17.
//

import UIKit



class MyCheckListSettingViewController: UIViewController{
    
    var addTask: [String] = []
    var taskIndex = 0
    
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTaped(_:)), for: .touchUpInside)
        
        return button
    }()
   
    let completeButton : UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(completeButtonTaped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    
    
    var contentTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .white
        textView.textInputView.backgroundColor = .systemBlue
        textView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.scrollIndicatorInsets = .init(top: 10, left: 10, bottom: 10, right: 20)
        return textView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 작성해보세요"
        textField.backgroundColor = .lightGray
        textField.textColor = .systemBlue
       
        return textField
    }()
    
    @objc func closeButtonTaped(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    
    @objc func completeButtonTaped(_ sender: UIButton){
        //완료 버튼 누를시
        
        
        guard let title = titleTextField.text else {return}
        //텍스트 필드에 적은 내용
        if let task = UserDefaults.standard.object(forKey: "MyCheckListTasks UserDefaults") as? [String]{
            addTask = task
        }
        addTask.append(title)
        
        //addTask 문자열 배열에 저장
        UserDefaults.standard.set(addTask,forKey: "MyCheckListTasks UserDefaults")
        
        //MARK: 이곳을 수정해야함
        
        let rootView = presentingViewController as? MyCheckListViewController
        
        self.presentingViewController?.dismiss(animated: true, completion: {
            guard let rootView = rootView else {return}
            
            print("응 아니야")
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setConstraints()
    }
    
    private func setConstraints(){
        self.view.addSubview(closeButton)
        self.view.addSubview(completeButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(titleTextField)
        self.view.addSubview(contentLabel)
        self.view.addSubview(contentTextView)
        
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),

            completeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            completeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            completeButton.heightAnchor.constraint(equalToConstant: 35),
            completeButton.widthAnchor.constraint(equalToConstant: 35),
            
            
            titleLabel.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            
            titleTextField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            titleTextField.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 11),
            
            contentLabel.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            
            contentTextView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 30),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            contentTextView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3)
            
            ])
    }
}
