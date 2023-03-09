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
        cell.writerLabel.text = "작성자:" + groupListArray[indexPath.row].writer
        cell.lastIndex = groupListArray[indexPath.row].image.count
        
        
        for (index, imageName) in groupListArray[indexPath.row].image.enumerated() {
            Storage.storage().reference().child(imageName).getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                }
                else{
                    let image = UIImage(data: data!)
                    if index == 0{
                        
                        cell.cellimageView.image = image!
                        cell.imageScrollView.addSubview(cell.cellimageView)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = 1
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(1), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                    if index == 1{
                        cell.cellimageView2.image = image!
                        cell.imageScrollView.addSubview(cell.cellimageView2)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = 2
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(2), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                    if index == 2{
                        cell.cellimageView3.image = image!
                        cell.imageScrollView.addSubview(cell.cellimageView3)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = 3
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(3), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                    if index == 3{
                        cell.cellimageView4.image = image!
                        cell.imageScrollView.addSubview(cell.cellimageView4)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = 4
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(4), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                    if index == 4{
                        cell.cellimageView5.image = image!
                        cell.imageScrollView.addSubview(cell.cellimageView5)
                        if self.groupListArray[indexPath.row].image.count - 1 == index{
                            cell.pageControl.numberOfPages = 5
                            cell.imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(5), height: UIScreen.main.bounds.width)
                            
                        }
                    }
                    
                    
                }
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return groupListTableView.bounds.height
    }
    
}

