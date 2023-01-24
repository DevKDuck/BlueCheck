//
//  MyCheckListSettingViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/17.
//

import UIKit

class MyCheckListSettingViewController: UIViewController{
    
    
    var taskIndex = 0
    weak var delegate: TableViewCellDelegate?
    var taskArray: [MyCheckListTask]?
    var taskImportance: Importance = .normal
    
    var taskAddOrModify = 0 // 0이면 추가, 1이면 수정
    
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["매우 중요", "중요", "보통"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
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
            taskArray?.append(MyCheckListTask(title: title, content: content, importance: taskImportance.rawValue))
            
        }//추가
        else if taskAddOrModify == 1{
            if taskArray != nil {
                taskArray?[taskIndex] = MyCheckListTask(title: title, content: content, importance: taskImportance.rawValue)
            }
        }
        
        let MyCheckListTableViewTasks = taskArray
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(MyCheckListTableViewTasks){
            UserDefaults.standard.set(encoded, forKey: "MyCheckListTableViewTasks UserDefaults")
        }
        
        if let reloadData = self.delegate?.delegateFunction(){
            reloadData
        }
        self.presentingViewController?.dismiss(animated: true)
        //텍스트 필드를 불렀어 그러면 추가할때는 .append를 하는게 맞아 그리고 수정할때는 [taskIndex]만 수정을 하는게 맞아
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        guard let savedData = UserDefaults.standard.object(forKey: "MyCheckListTableViewTasks UserDefaults") as? Data else {return}
        let decoder = JSONDecoder()
        if let saveObject = try? decoder.decode([MyCheckListTask].self, from: savedData){
            taskArray = saveObject
        }
        segementControlConfigure()
        setConstraints()
        setTextField()
        
        
    }
    
    func segementControlConfigure(){
        self.segmentedControl.addTarget(self, action: #selector(didChangeImportance(segment: )), for: .valueChanged)
        
        switch taskArray?[taskIndex].importance{
        case "매우 중요":
            self.segmentedControl.selectedSegmentIndex = 0
        case "중요":
            self.segmentedControl.selectedSegmentIndex = 1
        case "보통":
            self.segmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
        self.didChangeImportance(segment: self.segmentedControl)
    }
    
    @objc func didChangeImportance(segment: UISegmentedControl){
        switch segment.selectedSegmentIndex{
        case 0:
            taskImportance = .veryImportant
        case 1:
            taskImportance = .important
        case 2:
            taskImportance = .normal
        default:
            taskImportance = .important
        }
    }
    
    
    func setTextField(){
        if taskAddOrModify == 0{
            
        } // 추가
        else if taskAddOrModify == 1{
            if let taskArray = taskArray{
                titleTextField.text = taskArray[taskIndex].title
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
        self.view.addSubview(segmentedControl)
        
        
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
            
            segmentedControl.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            
            titleLabel.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 20),
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
