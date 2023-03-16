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
    
    var imageArray = [UIImage]()
    
    lazy var addContentButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(tapAddContentButton(_:)))
        return button
    }()
    
    @objc func tapAddContentButton(_ sender: UIButton){
        
        let goVC = CreateEachGroupRecordsContentViewController()
        goVC.currentUserEmail = self.currentUserEmail
        goVC.groupDocumentName = self.groupDocumentName
        goVC.tag = 0
        goVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(goVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFireStoreData()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    let groupListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GroupListCollectionViewCell.self, forCellReuseIdentifier: "GroupListCollectionViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.addContentButton
        setTableViewLayoutConstraints()
        
        
    }
    
    func setTableViewLayoutConstraints(){
        self.view.addSubview(groupListTableView)
        
        groupListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        groupListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        groupListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        groupListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    
    
    func getFireStoreData() {
        
        Firestore.firestore().collection(self.groupDocumentName).document("ALL").collection("Record").getDocuments { querySnapshot, error in
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
            
                self.groupListTableView.reloadData()
        }
        
    }
    
    
}

extension GroupListCollectionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCollectionViewCell", for: indexPath) as? GroupListCollectionViewCell else {return UITableViewCell()}
        cell.backgroundColor = .white
        cell.titleLabel.text = "제목: " + groupListArray[indexPath.row].title
        cell.contentLabel.text = "내용: " + groupListArray[indexPath.row].content
        cell.startDateLabel.text = "시작 날짜: " + groupListArray[indexPath.row].startDate
        cell.endDateLabel.text = "종료 날짜: " + groupListArray[indexPath.row].endDate
        cell.writerLabel.text = "작성자: " + groupListArray[indexPath.row].writer
        cell.modifyButton.tag = indexPath.row
        
            
        for (index, imageName) in groupListArray[indexPath.row].image.enumerated() {
            Storage.storage().reference().child(imageName).getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                }
                else{
                    let image = UIImage(data: data!)
                    guard let image = image else {return}
                    
                    switch index {
                    case 0:
                        cell.cellimageView.image = image
                        addImageScrollView(imageView: cell.cellimageView, index: 0)
                    case 1:
                        cell.cellimageView2.image = image
                        addImageScrollView(imageView: cell.cellimageView2, index: 1)
                    case 2:
                        cell.cellimageView3.image = image
                        addImageScrollView(imageView: cell.cellimageView3, index: 2)
                    case 3:
                        cell.cellimageView4.image = image
                        addImageScrollView(imageView: cell.cellimageView4, index: 3)
                    case 4:
                        cell.cellimageView5.image = image
                        addImageScrollView(imageView: cell.cellimageView5, index: 4)
                        
                    default:
                        break
                        
                    }
                    
                    func addImageScrollView(imageView: UIImageView, index: Int){
                        cell.imageScrollView.addSubview(imageView)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = index + 1
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(index+1), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                   
                }
            }
            
        }
        
        cell.modifyButton.addTarget(self, action: #selector(tapModifyButton(_:)), for: .touchUpInside)
        
        
        return cell
    }
    func failDeleteAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(confirm
        )
        self.present(alert, animated: false)
    }
    
    @objc func tapModifyButton(_ sender: UIButton){
        let alert = UIAlertController(title: "글을 관리할 수 있습니다.", message: "글관리 가능", preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "삭제하기", style: .default){ _ in
            print("삭제완료")
            
            // 자신이 쓴 글이라면 삭제할 수 있는 권한주기
            if self.groupListArray[sender.tag].writerEmail == self.currentUserEmail{
                //ALL삭제
                Firestore.firestore().collection(self.groupDocumentName).document("ALL").collection("Record").document(self.groupListArray[sender.tag].documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                //개인 삭제
                Firestore.firestore().collection(self.groupDocumentName).document(self.currentUserEmail).collection("Group").document(self.groupListArray[sender.tag].documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        
                    }
                }
                //스토리지 삭제
                for image in self.groupListArray[sender.tag].image{
                    let desertRef = Storage.storage().reference().child(image)
                    
                    // Delete the file
                    desertRef.delete { error in
                        if let error = error {
                            print("Uh-oh, an error occurred!: \(error.localizedDescription)")
                        } else {
                            // File deleted successfully
                        }
                    }
                }
                self.getFireStoreData()
                self.groupListTableView.reloadData()
            }
            else{
                self.failDeleteAlert(title: "글을 삭제할 수 없습니다.", message: "작성자만 삭제할 수 있습니다.")
            }

        }
        
        let modify = UIAlertAction(title: "수정하기", style: .default){ _ in
            
            if self.groupListArray[sender.tag].writerEmail == self.currentUserEmail{
                let modifyVC = CreateEachGroupRecordsContentViewController()
                modifyVC.tag = 1
                modifyVC.groupDocumentName = self.groupDocumentName
                modifyVC.currentUserEmail = self.currentUserEmail
                modifyVC.completeButton.title = "수정"
                modifyVC.titleTextField.text = self.groupListArray[sender.tag].title
                modifyVC.documentID = self.groupListArray[sender.tag].documentID
                modifyVC.modifyArray = self.groupListArray[sender.tag].image
                modifyVC.contentTextView.text = self.groupListArray[sender.tag].content
                modifyVC.startDate = self.groupListArray[sender.tag].startDate
                modifyVC.endDate = self.groupListArray[sender.tag].endDate
            
                self.navigationController?.pushViewController(modifyVC, animated: false)
            }
            else{
                self.failDeleteAlert(title: "글을 수정할 수 없습니다.", message: "작성자만 수정할 수 있습니다.")
            }
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(modify)
        alert.addAction(cancel)
        
        self.present(alert, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return groupListTableView.bounds.height
    }
    
}

