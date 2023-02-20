//
//  CreateEachGroupRecordsContentViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/06.
//

import UIKit
import AVFoundation

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
        
        imageViewTapGestureAttributes()
        setAttributesDatePicker()
        setLayoutConstraints()
        picker.delegate = self
        
    }
    
    private func imageViewTapGestureAttributes(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapRecordImage(_:)))
        recordImage.addGestureRecognizer(tapGesture)
        recordImage.isUserInteractionEnabled = true //사용자
    }
    
    
    @objc func tapRecordImage (_ sender: UIImageView){
        let alert = UIAlertController(title: "인증 사진 찾기", message: "자랑스럽게 이루어낸 사진을 공유하세요!", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "카메라", style: .default) { camera in
//            let pickerController = UIImagePickerController()
//            pickerController.sourceType = .camera
//            pickerController.allowsEditing = false
//            pickerController.mediaTypes = ["public.image"]
////            pickerController.delegate = self
//            self.present(pickerController, animated: true)
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
        startDatePicker.addTarget(self, action: #selector(valueChangedDatePicker(_:)), for: .valueChanged)
        
        
        endDatePicker.preferredDatePickerStyle = .automatic
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.locale = Locale(identifier: "ko-KR")
        endDatePicker.timeZone  = .autoupdatingCurrent
        endDatePicker.addTarget(self, action: #selector(valueChangedDatePicker(_:)), for: .valueChanged)
    }
    
    @objc func valueChangedDatePicker(_ sender: UIDatePicker){
        //시작날짜 종료날짜 변경필요
        print(sender.date)
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(topView)
        self.view.addSubview(completeButton)
        self.view.addSubview(disMissButton)
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
        
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        disMissButton.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        
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
        
        
        present(picker, animated: false)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false)
    }
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.recordImage.image = image
        picker.dismiss(animated: true, completion: nil)
        // 비디오인 경우 - url로 받는 형태
        //    guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
        //      picker.dismiss(animated: true, completion: nil)
        //      return
        //    }
        //    let video = AVAsset(url: url)
    }
}
