//
//  GroupListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/22.
//

import UIKit
import FirebaseStorage
import Kingfisher


class GroupListCollectionViewCell: UICollectionViewCell{
    
    static let identifier = "GroupListCollectionViewCell"
    
    
    var imageArray: [GroupListTask] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let writerLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let endDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GroupListImageCollectionViewCell.self, forCellWithReuseIdentifier: "GroupListImageCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let authImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "square")
        imageView.backgroundColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var urlArray: [URL] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraints()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        for i in imageArray{
            Storage.storage().reference().child(i.image).listAll{ result , error in
                for item in result!.items{
                    print(item)
                }
            }
//            Storage.storage().reference().child(i.image).downloadURL { (url,error) in
//                if let error = error {
//                    print("FireStorage Get Image Error : \(error.localizedDescription)")
//                }
//                else{
//                    self.urlArray.append(url!)
//                }
//
//            }
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setLayoutConstraints(){
        self.addSubview(titleLabel)
        self.addSubview(writerLabel)
        contentView.addSubview(imageCollectionView)
//        self.addSubview(authImage)
        self.addSubview(startDateLabel)
        self.addSubview(endDateLabel)
        self.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            
            writerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            writerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            imageCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 10),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),


//            authImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 10),
//            authImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            authImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            authImage.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
//
            
            startDateLabel.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor, constant: 10),
            startDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            
            endDateLabel.topAnchor.constraint(equalTo: self.startDateLabel.bottomAnchor, constant: 10),
            endDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            contentLabel.topAnchor.constraint(equalTo: self.endDateLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
        ])
        
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
            
    }
}

extension GroupListCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListImageCollectionViewCell", for: indexPath) as? GroupListImageCollectionViewCell else {return UICollectionViewCell()}
        
        Storage.storage().reference().child(self.imageArray[indexPath.row].image).downloadURL { (url,error) in
            if let error = error {
                print("FireStorage Get Image Error : \(error.localizedDescription)")
            }
            else{
                cell.imageView.kf.setImage(with: url)
                cell.imageView.contentMode = .scaleToFill
            }
            
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCollectionView.frame.width , height: imageCollectionView.frame.height)
    }
}
