//
//  CreateGoupViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


protocol GetInvitationList: AnyObject{
    func getUserNameArray(nameArray:[String])
    func getUserEmailArray(emailArray:[String])
}



class CreateGroupViewController: UIViewController, GetInvitationList{
    
    func getUserNameArray(nameArray: [String]) {
       userNameArray = nameArray
    }
    
    func getUserEmailArray(emailArray: [String]) {
        userEmailArray = emailArray
    }
    
    
    let db = Firestore.firestore()
    var currentUserEmail: String = ""
    var meetObject = "기타"
    var userEmailArray: [String] = []
    var userNameArray = [String]()
    
    
    let groupTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "그룹명"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    let groupTitleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(string: " 그룹명을 작성해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .darkGray
        return textField
    }()
    
    let groupObjectiveLabel : UILabel = {
        let label = UILabel()
        label.text = "목표"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var studyButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var exerciseButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var travelButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var restaurantButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var etcButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var objectiveButtonArray = [UIButton]()
    
    @objc func tapButton(_ sender: UIButton){
        objectiveButtonArray.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        
        if let objectText = sender.titleLabel?.text {
            meetObject = objectText
        }
        
    }
    
//    let objectiveStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .equalSpacing
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    
    lazy var objectiveStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [studyButton,exerciseButton,travelButton,restaurantButton,etcButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "구체적인 내용"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let textViewPlaceHolder = "\n 시기 - ex)일주일에 3번 \n \n \n 내용 - ex)운동 인증과 식단을 올리는 모임입니다.💪"
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18)
        textView.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textView.textInputView.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.scrollIndicatorInsets = .init(top: 10, left: 10, bottom: 10, right: 20)
        textView.layer.cornerRadius = 20
        textView.text = textViewPlaceHolder
        textView.delegate = self
        textView.textColor = .lightGray
        return textView
    }()
    
    lazy var inviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("인원 초대", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(tapInviteButoon(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapInviteButoon(_ sender: UIButton){
        let goInviteListViewController = InviteListViewController()
        goInviteListViewController.modalPresentationStyle = .fullScreen
        goInviteListViewController.inviteDatadelegate = self
        goInviteListViewController.userNameArray = userNameArray
        goInviteListViewController.userEmailArray = userEmailArray
        
        self.present(goInviteListViewController, animated: true)
    }
    
    
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("생성", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(tapCreateButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapCreateButton(_ sender: UIButton){
        //MARK: 생성 버튼클릭시 정보들을 GroupList에 reload 해야함
        firestoreCreateDocuments()
        self.dismiss(animated: true)
    }
    
    //MARK: Firebase update
    func firestoreCreateDocuments(){
        guard let titleText = groupTitleTextField.text, let contentText = contentTextView.text else {return}
        let data = ["groupName" : titleText, "object" : meetObject, "content" : contentText]
        let randomNum = Float.random(in: 0...10)
        
//        //uid + 랜덤값 으로 collection 만들기
//        guard let uID = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("user").document(currentUserEmail).collection("Group").document(currentUserEmail + "\(randomNum)").setData(data){ error in
            if let error = error{
                print("Error:\(error.localizedDescription)")
                return
            }
        }
        
        
        Firestore.firestore().collection(currentUserEmail + "\(randomNum)").document(currentUserEmail).setData([:]){error in
            if let error = error{
                print("RandomNumCollectionCreateError: \(error.localizedDescription)")
                return
            }
        }

        //MARK: 초대
        let inviteData = ["groupName": titleText,"object" : meetObject, "content" : contentText, "status": "hold", "groupNumber" : currentUserEmail + "\(randomNum)"]
        userEmailArray.forEach{
            Firestore.firestore().collection("user").document($0).collection("Invite status").document(currentUserEmail + "\(randomNum)").setData(inviteData){ error in
                if let error = error{
                    print("Error:\(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        button.setTitleColor(.darkGray, for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(tapCancelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapCancelButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        setTitleAndImageButtonConfig()
        setLayoutConstraints()
        self.view.backgroundColor = .white
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
        view.endEditing(true)
    }
    
    
    func setTitleAndImageButtonConfig(){
        buttonConfig(title: "공부", imageSystemName: "book", button: studyButton)
        buttonConfig(title: "운동", imageSystemName: "figure.strengthtraining.traditional", button: exerciseButton)
        buttonConfig(title: "여행", imageSystemName: "figure.stairs", button: travelButton)
        buttonConfig(title: "맛집", imageSystemName: "light.recessed", button: restaurantButton)
        buttonConfig(title: "기타", imageSystemName: "guitars", button: etcButton)
        
        objectiveButtonArray.append(studyButton)
        objectiveButtonArray.append(exerciseButton)
        objectiveButtonArray.append(travelButton)
        objectiveButtonArray.append(restaurantButton)
        objectiveButtonArray.append(etcButton)
        
    }
    
    func buttonConfig(title: String, imageSystemName: String, button: UIButton){
        var config = UIButton.Configuration.filled()
        
        let handler: UIButton.ConfigurationUpdateHandler = { btn in
            switch btn.state{
            case .normal:
                btn.configuration?.baseBackgroundColor = .white
                btn.configuration?.baseForegroundColor = .systemBlue
            case .selected:
                btn.configuration?.baseForegroundColor = .white
                btn.configuration?.baseBackgroundColor = .systemBlue
            default:
                break
            }
        }
        config.title = title
        config.image = UIImage(systemName: imageSystemName)
        config.imagePlacement = .bottom
        config.background.strokeColor = UIColor.systemBlue
        config.background.strokeWidth = 3
        button.configuration = config
        button.configurationUpdateHandler = handler
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(groupTitleLabel)
        self.view.addSubview(groupTitleTextField)
        self.view.addSubview(groupObjectiveLabel)
        
        self.view.addSubview(studyButton)
        self.view.addSubview(exerciseButton)
        self.view.addSubview(travelButton)
        self.view.addSubview(restaurantButton)
        self.view.addSubview(etcButton)
        
        self.view.addSubview(self.objectiveStackView)
        
        self.view.addSubview(contentLabel)
        self.view.addSubview(contentTextView)
        
        self.view.addSubview(inviteButton)
        
        self.view.addSubview(cancelButton)
        self.view.addSubview(createButton)
        
        groupTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        groupTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        groupObjectiveLabel.translatesAutoresizingMaskIntoConstraints = false
        studyButton.translatesAutoresizingMaskIntoConstraints = false
        exerciseButton.translatesAutoresizingMaskIntoConstraints = false
        travelButton.translatesAutoresizingMaskIntoConstraints = false
        restaurantButton.translatesAutoresizingMaskIntoConstraints = false
        etcButton.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            groupTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            groupTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            groupTitleTextField.topAnchor.constraint(equalTo: self.groupTitleLabel.bottomAnchor, constant: 20),
            groupTitleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            groupTitleTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            groupTitleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            groupObjectiveLabel.topAnchor.constraint(equalTo: self.groupTitleTextField.bottomAnchor,constant: 30),
            groupObjectiveLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            
            objectiveStackView.topAnchor.constraint(equalTo: self.groupObjectiveLabel.bottomAnchor, constant: 20),
            objectiveStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            objectiveStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            
            contentLabel.topAnchor.constraint(equalTo: self.objectiveStackView.bottomAnchor,constant: 30),
            contentLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            cancelButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2 - 30),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            
            createButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2 - 30),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            createButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            inviteButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            inviteButton.heightAnchor.constraint(equalToConstant: 44),
            inviteButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inviteButton.bottomAnchor.constraint(equalTo: self.cancelButton.topAnchor, constant: -30),

            contentTextView.topAnchor.constraint(equalTo: self.contentLabel.bottomAnchor, constant: 30),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: self.inviteButton.topAnchor, constant: -30)
        ])
        
//        [studyButton,exerciseButton,travelButton,restaurantButton,etcButton].map{
//            self.objectiveStackView.addArrangedSubview($0)
//        }
        
    }
    
}

extension CreateGroupViewController: UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == textViewPlaceHolder {
                textView.text = nil
                textView.textColor = .black
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                textView.text = textViewPlaceHolder
                textView.textColor = .lightGray

            }
        }
}
