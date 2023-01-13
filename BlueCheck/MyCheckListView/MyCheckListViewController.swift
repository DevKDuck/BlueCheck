//
//  MyCheckListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

class MyCheckListViewController: UIViewController{
    
    let uiview: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .green
        return uiView
    }()
    
    let collectionView: UICollectionView = {
           
           let layout = UICollectionViewFlowLayout()
           layout.minimumLineSpacing = 10
           
           layout.scrollDirection = .vertical
           layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           
           return cv
       }()
    
    var testcollecionArray = ["1","2","3"]
    
    
    let customCalender = Calendar(identifier: .japanese)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: CollectionView 설정
        
        collectionView.backgroundColor = .systemBlue
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
//        self.view.addSubview(uiview)
//
//        uiview.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//        uiview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//        uiview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
//        uiview.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//        uiview.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
//        ])
        
    }
    
    
    private func setConstraints() {
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
}

extension MyCheckListViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testcollecionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCheckListCollectionViewCell", for: indexPath) as? MyCheckListCollectionViewCell else {return UICollectionViewCell()}
        return cell
    }
    
}
