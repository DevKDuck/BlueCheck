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

import BSImagePicker
import Photos

class CreateEachGroupRecordsContentViewController: UIViewController{
    
    var currentUserEmail: String = ""
    var groupDocumentName = ""
    var currentUserName: String = ""
    var currentUserNickName: String = ""
    
    var modifyArray = [String]()
    
    var tag = 0
    
    var documentID: String = ""
    
    
    
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
    
    
    var selectedAssetsArray = [PHAsset]()
    var userSelectedImages = [UIImage(systemName: "plus")]
    
    
    var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 3)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(CreateEachGroupRecordsContentViewImageCollectionCell.self, forCellWithReuseIdentifier: "CreateEachGroupRecordsContentViewImageCollectionCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    //    let picker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if tag == 1{
                userSelectedImages.removeAll()
                for imageName in modifyArray {
                    Storage.storage().reference().child(imageName).getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print(error)
                        }
                        else{
                            let image = UIImage(data: data!)
                            self.userSelectedImages.append(image!)
                        }
                    }
                }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.imageCollectionView.reloadData()
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getFireStoreData()
        //        imageViewTapGestureAttributes()
        setAttributesDatePicker()
        setLayoutConstraints()
        self.navigationItem.rightBarButtonItem = completeButton
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        //        picker.delegate = self
        
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
                    self.currentUserName = FirestoreData["name"] as? String ?? "이름 없음"
                    self.currentUserNickName = FirestoreData["nickName"] as? String ?? "닉네임 없음"
                }
            }
            
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
        
        if tag == 0{
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
            
            
            //새로운 내용을 만들때 만드는 문서
            let newDoc = Firestore.firestore().collection(groupDocumentName).document(currentUserEmail).collection("Group").document()
            
            var imageDocArray : [String] = []
            
            for image in userSelectedImages {
                let randomNum = newDoc.documentID + String(Float.random(in: 0...10))
                imageDocArray.append(randomNum)
                uploadImage(img: image!, randomNum: randomNum)
            }
            
            
            
            let data = ["title" : titleTextField.text!, "startDate" : startDate, "endDate" : endDate, "content": contentTextView.text!, "writer": currentUserNickName, "image" : imageDocArray, "documentID" : newDoc.documentID] as [String : Any]
            
            newDoc.setData(["DocID" : newDoc.documentID])
            
            //        //그룹 -> Record -> 난수이미지 : data 로 업데이트
            let groupDoc = Firestore.firestore().collection(groupDocumentName).document("ALL").collection("Record").document(newDoc.documentID)
            groupDoc.setData(data)
        }
        
        if tag == 1{
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
            
            
            //Stroage 이미지 삭제
            Firestore.firestore().collection(groupDocumentName).document("ALL").collection("Record").document(documentID).getDocument(){ snapShot, error in
                if let error = error{
                    print("RemoveFirestore getImageRefError: \(error)")
                }
                else{
                    guard let snapShot = snapShot else {return}
                    let data = snapShot.data()
                    guard let imageArray = data?["image"] as? [String] else {return}
                    for image in imageArray{
                        let desertRef = Storage.storage().reference().child(image)

                        desertRef.delete { error in
                          if let error = error {
                              print("Delete the file error: \(error.localizedDescription)")
                          } else {
                            // File deleted successfully
                          }
                        }
                    }
                    
                            
                }
                
            }
            
            //새로운 내용을 만들때 만드는 문서
            let doc = Firestore.firestore().collection(groupDocumentName).document("ALL").collection("Record").document(documentID)
            
            var imageDocArray : [String] = []
            
            for image in userSelectedImages {
                let randomNum = documentID + String(Float.random(in: 0...10))
                imageDocArray.append(randomNum)
                uploadImage(img: image!, randomNum: randomNum)
            }
            
            
            
            let data = ["title" : titleTextField.text!, "startDate" : startDate, "endDate" : endDate, "content": contentTextView.text!, "writer": currentUserNickName, "image" : imageDocArray, "documentID" : documentID] as [String : Any]
            
            doc.updateData(data){ err in
                if let err = err {
                       print("Error updating document: \(err)")
                   } else {
                       print("Document successfully updated")
                   }
            }
            
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func uploadImage(img: UIImage, randomNum: String){
        var data = Data()
        data = img.jpegData(compressionQuality: 1.0)!
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        Storage.storage().reference().child(randomNum).putData(data,metadata: metaData){ (metaData,error) in
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
        
        self.view.addSubview(imageCollectionView)
        
        self.view.addSubview(recordImagebarView)
        
        self.view.addSubview(contentTextView)
        
        
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
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
            
            
            //            recordImage.topAnchor.constraint(equalTo: self.datebarView.bottomAnchor, constant: 5),
            //            recordImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            //            recordImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            //            recordImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            
            imageCollectionView.topAnchor.constraint(equalTo: self.datebarView.bottomAnchor, constant: 5),
            imageCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            
            recordImagebarView.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor,constant: 5),
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
        
    }
    
    func openLibrary(){
        //        self.picker.sourceType = .photoLibrary
        //        present(picker, animated: false)
        pressImageLibrary()
        
    }
    
    func pressImageLibrary(){
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5 //최대개수 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        presentImagePicker(imagePicker, select: {(assets) in
            
        }, deselect: {(assets) in
            
        }, cancel: {(assets) in
            
        }, finish: {(assets) in
            if assets.count > 0 {
                self.userSelectedImages.removeAll()
            }
            //사진을 하나이상 고르면 + 마크 없애기
            
            for asset in 0..<assets.count{
                self.selectedAssetsArray.append(assets[asset])
            }
            self.convertAssetToImages()
            self.imageCollectionView.reloadData()
            imagePicker.dismiss(animated: false)
        })
    }
    
    func convertAssetToImages() {
        
        if selectedAssetsArray.count != 0 {
            
            for i in 0..<selectedAssetsArray.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true //비동기
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssetsArray[i],
                                          targetSize: CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 3),
                                          contentMode: .aspectFill,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 1.0)
                let newImage = UIImage(data: data!)
                
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
    
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("\(selectedImage)사진은 정상적으로 찍힘")
            self.userSelectedImages.append(selectedImage)
            self.imageCollectionView.reloadData()
            picker.dismiss(animated: true)
        }
    }
}

extension CreateEachGroupRecordsContentViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userSelectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateEachGroupRecordsContentViewImageCollectionCell", for: indexPath) as? CreateEachGroupRecordsContentViewImageCollectionCell else {return UICollectionViewCell()}
        
        if tag == 0{
            cell.imageView.image = userSelectedImages[indexPath.row]
        }
        if tag == 1{
            cell.imageView.image = userSelectedImages[indexPath.row]
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    
}
