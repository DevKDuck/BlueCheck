//
//  GroupListCollectionViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class GroupListCollectionViewController: UIViewController{
    
    var currentUser: User?
    var groupDocumentName = ""
    var groupListArray : [GroupListTask] = []
    var imageArray : [UIImage] = []
    
    lazy var addContentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(tapAddContentButton(_:)))
        return button
    }()
    
    @objc func tapAddContentButton(_ sender: UIButton){
        
        let goVC = CreateEachGroupRecordsContentViewController()
        goVC.currentUser = self.currentUser
        goVC.groupDocumentName = self.groupDocumentName
        
        goVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(goVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GroupListCollectionViewCell.self, forCellWithReuseIdentifier: "GroupListCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.title = "그룹명"
        self.navigationItem.rightBarButtonItem = self.addContentButton
        setLayoutConstraints()
        getFireStoreData()
        
    }
    
    func setLayoutConstraints(){
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func getFireStoreData() {
        Firestore.firestore().collection(groupDocumentName).document(currentUser!.uid).collection("Group").getDocuments { querySnapshot, error in
            
            if let error = error {
                print("GroupListCollectionView - GetFireStoreDataError: \(error.localizedDescription)")
            }else{
                for document in querySnapshot!.documents{
                    
                    do{
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let taskInfo = try JSONDecoder().decode(GroupListTask.self, from: jsonData)
                      
//                        Storage.storage().reference().child(taskInfo.image).downloadURL { (url,error) in
//
//
//                        }
//
                        
                        self.groupListArray.append(taskInfo)
                        
                        
                    }catch let err{
                        print("err: \(err)")
                    }
                    
                }
                print(self.imageArray)
                self.collectionView.reloadData()
            }
        }
    }
}


extension GroupListCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groupListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListCollectionViewCell", for: indexPath) as? GroupListCollectionViewCell else {return UICollectionViewCell()}
        cell.backgroundColor = .white
        cell.titleLabel.text = "제목: " + groupListArray[indexPath.row].title
        cell.contentLabel.text = "내용: " + groupListArray[indexPath.row].content
        cell.startDateLabel.text = "시작 날짜: " + groupListArray[indexPath.row].startDate
        cell.endDateLabel.text = "종료 날짜: " + groupListArray[indexPath.row].endDate
//        cell.authImage.image = imageArray[indexPath.row]
        return cell
    }
    
}

