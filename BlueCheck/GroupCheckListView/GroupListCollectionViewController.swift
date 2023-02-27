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
import Kingfisher




class GroupListCollectionViewController: UIViewController {
    
    
    var currentUserEmail: String = ""
    var groupDocumentName = ""
    var groupListArray : [GroupListTask] = []
    
    lazy var addContentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(tapAddContentButton(_:)))
        return button
    }()
    
    @objc func tapAddContentButton(_ sender: UIButton){
        
        let goVC = CreateEachGroupRecordsContentViewController()
        goVC.currentUserEmail = self.currentUserEmail
        goVC.groupDocumentName = self.groupDocumentName
        goVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(goVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getFireStoreData()
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
        self.navigationItem.rightBarButtonItem = self.addContentButton
        setLayoutConstraints()
        
        
    }
    
    func setLayoutConstraints(){
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func getFireStoreData() {
        Firestore.firestore().collection(groupDocumentName).document("ALL").collection("Record").getDocuments { querySnapshot, error in
            
            if let error = error {
                print("GroupListCollectionView - GetFireStoreDataError: \(error.localizedDescription)")
            }else{
                self.groupListArray.removeAll()
                do{
                    for document in querySnapshot!.documents{
                        let data = document.data()
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let taskInfo = try JSONDecoder().decode(GroupListTask.self, from: jsonData)
                        self.groupListArray.append(taskInfo)

                    }
                }catch let err{
                    print("err: \(err)")
                }
            }
            self.collectionView.reloadData()
            
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
        
        DispatchQueue.global().async {
            Storage.storage().reference().child(self.groupListArray[indexPath.row].image).downloadURL { (url,error) in
                if let error = error {
                    print("FireStorage Get Image Error : \(error.localizedDescription)")
                }
                else{
                    DispatchQueue.main.async {
                        cell.authImage.kf.setImage(with: url)
                        cell.authImage.contentMode = .scaleToFill
                    }
                }
            }
        }
        
        
        return cell
    }
    
}
