//
//  MyCheckListSettingViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/17.
//

import UIKit

class MyCheckListSettingViewController: UIViewController{
    
    var titleTask: [String] = []     //제목
    var contentsTask: [String] = []   //내용
    
    var taskIndex = 0
    weak var delegate: TableViewCellDelegate?
    var taskArray: [MyCheckListTask]?
    
    var taskAddOrModify = 0 // 0이면 추가, 1이면 수정
    
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
        
        guard let title = titleTextField.text else {return}
        guard let content = contentTextView.text else {return}
        
        if taskAddOrModify == 0{
//            titleTask.append(title)
//            contentsTask.append(content)
            taskArray?.append(MyCheckListTask(title: title, content: content))
            
        }//추가
        else if taskAddOrModify == 1{
            if var taskArray = taskArray {
                taskArray[taskIndex] = MyCheckListTask(title: title, content: content)
            }
//            titleTask[taskIndex] = title
//            contentsTask[taskIndex] = content
        }
        
        let MyCheckListTableViewTasks = taskArray
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(MyCheckListTableViewTasks){
            UserDefaults.standard.set(encoded, forKey: "MyCheckListTableViewTasks UserDefaults")
        }
        
//        UserDefaults.standard.set(titleTask, forKey: "MyCheckListTasks UserDefaults")
//        UserDefaults.standard.set(titleTask, forKey: "MyCheckListContentsTasks UserDefaults")
//
        
        if let reloadData = self.delegate?.delegateFunction(){
            reloadData
        }
        self.presentingViewController?.dismiss(animated: true)
        //텍스트 필드를 불렀어 그러면 추가할때는 .append를 하는게 맞아 그리고 수정할때는 [taskIndex]만 수정을 하는게 맞아
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setConstraints()
        setTextField()
        
    }
    
    
    func setTextField(){
        //1. 일단 addTask 는 UserDefault를 갖음
        //        if let task = UserDefaults.standard.object(forKey: "MyCheckListTasks UserDefaults") as? [String]{
        //            titleTask = task
        //        }
        //        if let contentsTaskArray = UserDefaults.standard.object(forKey: "MyCheckListContentsTasks UserDefaults") as? [String]{
        //
        //            contentsTask = contentsTaskArray
        //        }
        if let savedData = UserDefaults.standard.object(forKey: "MyCheckListTableViewTasks UserDefaults") as? Data{
            let decoder = JSONDecoder()
            if let saveObject = try? decoder.decode([MyCheckListTask].self, from: savedData){
                taskArray = saveObject
            }
        }
        
        if taskAddOrModify == 0{
            
        } // 추가
        else if taskAddOrModify == 1{
            /*
             1.텍스필드에 전에 있던 내용이 떠야함
             2.내용도 떠야함
             
             */
            if let taskArray = taskArray{
                titleTextField.text = taskArray[taskIndex].title   // 1
                contentTextView.text =  taskArray[taskIndex].content
            }
        }// 수정
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
