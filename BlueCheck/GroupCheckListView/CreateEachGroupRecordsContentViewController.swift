//
//  CreateEachGroupRecordsContentViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit
import MobileCoreServices

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CreateEachGroupRecordsContentViewController: UIViewController{
    
    var currentUserEmail: String = ""
    var groupDocumentName = ""
    var currentUserName: String = ""
    
    
    lazy var completeButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(tapCompleteButton(_:)))
        return button
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 작성해보세요"
        textField.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textField.textColor = .darkGray
        
        return textField
    }()
    
    let startLabel : UILabel = {
        let label = UILabel()
        label.text = "시작 날짜"
        label.textColor = .systemBlue
        return label
    }()
    
    private let startDatePicker = UIDatePicker()
    
    let endLabel : UILabel = {
        let label = UILabel()
        label.text = "종료 날짜"
        label.textColor = .systemRed
        return label
    }()
    
    private let endDatePicker = UIDatePicker()
    
    let recordImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.tennis")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        
        return imageView
    }()
    
    
    let titlebarView: UIView = {
        let barview = UIView()
        barview.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        barview.translatesAutoresizingMaskIntoConstraints = false
        return barview
    }()
    
    let datebarView: UIView = {
        let barview = UIView()
        barview.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        barview.translatesAutoresizingMaskIntoConstraints = false
        return barview
    }()
    
    let recordImagebarView: UIView = {
        let barview = UIView()
        barview.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        barview.translatesAutoresizingMaskIntoConstraints = false
        return barview
    }()
    
    
    var contentTextView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textView.textInputView.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        textView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.scrollIndicatorInsets = .init(top: 10, left: 10, bottom: 10, right: 20)
        textView.textColor = .darkGray
        return textView
    }()
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getFireStoreData()
        imageViewTapGestureAttributes()
        setAttributesDatePicker()
        setLayoutConstraints()
        self.navigationItem.rightBarButtonItem = completeButton
        picker.delegate = self
        
    }
    
    func getFireStoreData(){
        let db = Firestore.firestore()
        
        db.collection("user").document(currentUserEmail).getDocument{ snapshot, error in
            if let err = error{
                print("MyAccountView Error:\(err.localizedDescription)")
            }
            else{
                let data = snapshot?.data()
                if let FirestoreData = data {
                    self.currentUserName = FirestoreData["name"] as? String ?? ""
                }
            }
            
        }
    }
    
    private func imageViewTapGestureAttributes(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordImage(_:)))
        recordImage.addGestureRecognizer(tapGesture)
        recordImage.isUserInteractionEnabled = true //사용자
    }
    
    
    @objc func tapRecordImage (_ sender: UIImageView){
        let alert = UIAlertController(title: "인증 사진 찾기", message: "자랑스럽게 이루어낸 사진을 공유하세요!", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "카메라", style: .default) { camera in
            self.openCamera()
        }
        
        let album = UIAlertAction(title: "앨범", style: .default) { album in
            self.openLibrary()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        
        
        //MARK: ActionSheet의 모달스타일은 UIModalPresentationPopover라고 설명을 해주면서 UIModalPresentationPopover을 사용 할 때는 barButtonItem 또는 팝업에 대한 위치를 설정해줘야 되어 패드와 아이폰 나눔
        
        
        if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
            if let popoverController = alert.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 저장해줍니다.
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(alert, animated: true, completion: nil)
            }
        }

        else {
            self.present(alert, animated: true)
        }
        
    }
    
    private func setAttributesDatePicker() {
        startDatePicker.preferredDatePickerStyle = .compact
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.locale = Locale(identifier: "ko-KR")
        startDatePicker.timeZone  = .autoupdatingCurrent
        startDatePicker.addTarget(self, action: #selector(startValueChangedDatePicker(_:)), for: .valueChanged)
        
        
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.locale = Locale(identifier: "ko-KR")
        endDatePicker.timeZone  = .autoupdatingCurrent
        endDatePicker.addTarget(self, action: #selector(endValueChangedDatePicker(_:)), for: .valueChanged)
    }
    var startDate = ""
    var endDate = ""
    
    @objc func startValueChangedDatePicker(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        startDate = dateFormatter.string(from: sender.date)
    }
    
    
    @objc func endValueChangedDatePicker(_ sender: UIDatePicker){
        //시작날짜 종료날짜 변경필요
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        endDate = dateFormatter.string(from: sender.date)
    }
    
    @objc func tapCompleteButton(_ sender: UIButton){
        
        
        if startDate == "" {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            dateFormatter.locale = Locale(identifier:"ko_KR")
            startDate = dateFormatter.string(from: now)
        }
        if endDate == "" {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
            dateFormatter.locale = Locale(identifier:"ko_KR")
            endDate = dateFormatter.string(from: now)
        }
        
        guard let recordUIImage = recordImage.image else {return}
        
        //자신이 만들었나 확인하기 위해 아래 루트에 난수이미지통해 저장
        let newDoc = Firestore.firestore().collection(groupDocumentName).document(currentUserEmail).collection("Group").document()
        let data = ["title" : titleTextField.text!, "startDate" : startDate, "endDate" : endDate, "image" : newDoc.documentID, "content": contentTextView.text!, "writer": currentUserName ]
        
        newDoc.setData(["DocID" : newDoc.documentID])
        uploadImage(img: recordUIImage, docID: newDoc.documentID)
        
        
        
        //        //그룹 -> Record -> 난수이미지 : data 로 업데이트
        let groupDoc = Firestore.firestore().collection(groupDocumentName).document("ALL").collection("Record").document(newDoc.documentID)
        groupDoc.setData(data)
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func uploadImage(img: UIImage, docID: String){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        Storage.storage().reference().child(docID).putData(data,metadata: metaData){ (metaData,error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
        }
        
    }
    
    private func setLayoutConstraints(){
        
        self.view.addSubview(titleTextField)
        self.view.addSubview(titlebarView)
        
        self.view.addSubview(startLabel)
        self.view.addSubview(startDatePicker)
        
        
        self.view.addSubview(endLabel)
        self.view.addSubview(endDatePicker)
        
        self.view.addSubview(datebarView)
        self.view.addSubview(recordImage)
        self.view.addSubview(recordImagebarView)
        
        self.view.addSubview(contentTextView)
        
        
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        recordImage.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            titlebarView.topAnchor.constraint(equalTo: self.titleTextField.bottomAnchor,constant: 5),
            titlebarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titlebarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            titlebarView.heightAnchor.constraint(equalToConstant: 2),
            
            startDatePicker.topAnchor.constraint(equalTo: self.titlebarView.bottomAnchor, constant: 5),
            startDatePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            startLabel.centerYAnchor.constraint(equalTo: self.startDatePicker.centerYAnchor),
            startLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            startLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 5),
            
            
            //            startDatePicker.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 2),
            
            endDatePicker.topAnchor.constraint(equalTo: self.startDatePicker.bottomAnchor, constant: 5),
            endDatePicker.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            endLabel.centerYAnchor.constraint(equalTo: self.endDatePicker.centerYAnchor),
            endLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            endLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 5),
            
            
            //            endDatePicker.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 3),
            
            
            datebarView.topAnchor.constraint(equalTo: self.endDatePicker.bottomAnchor,constant: 5),
            datebarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            datebarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            datebarView.heightAnchor.constraint(equalToConstant: 2),
            
            
            recordImage.topAnchor.constraint(equalTo: self.datebarView.bottomAnchor, constant: 5),
            recordImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recordImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recordImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            
            recordImagebarView.topAnchor.constraint(equalTo: self.recordImage.bottomAnchor,constant: 5),
            recordImagebarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            recordImagebarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            recordImagebarView.heightAnchor.constraint(equalToConstant: 2),
            
            
            contentTextView.topAnchor.constraint(equalTo: self.recordImagebarView.bottomAnchor,constant: 5),
            contentTextView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
    }
}


extension CreateEachGroupRecordsContentViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func openCamera(){
        
        picker.sourceType = .camera
        picker.allowsEditing = false
//            picker.delegate = self
//            picker.mediaTypes = [UTType.image.identifier]
            
        present(picker, animated: false)
      
    }
    
    func openLibrary(){
        self.picker.sourceType = .photoLibrary
        present(picker, animated: false)
    }
    
    
    
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("\(selectedImage)사진은 정상적으로 찍힘")
            self.recordImage.image = selectedImage
            picker.dismiss(animated: true)
        }
    }
}
