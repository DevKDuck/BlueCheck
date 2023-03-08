//
//  GroupListCollectionViewCell.swift
//  BlueCheck
//
//  Created by duck on 2023/02/22.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher


class GroupListCollectionViewCell: UITableViewCell{
    
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
    
    
    let recorImage: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var imageNames = [UIImage(systemName: "xmark"),UIImage(systemName: "xmark"),UIImage(systemName: "xmark")]
    
    
     let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
        return scrollView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    
//    var urlArray: [URL] = []
//    var itemArray: [StorageReference] = []
    
    var imageDataArray: [String] = []

    let cellimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        return imageView
    }()
    let cellimageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        return imageView
    }()
    let cellimageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        return imageView
    }()
    let cellimageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        return imageView
    }()
    let cellimageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        return imageView
    }()

    var lastIndex: Int?
    var imageCount = 0
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageScrollView.delegate = self
        pageControl.currentPage = 0
//        pageControl.numberOfPages = lastIndex ?? 5
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray // 페이지를 암시하는 동그란 점의 색상
        pageControl.currentPageIndicatorTintColor = .systemBlue // 현재 페이지를 암시하는 동그란 점 색상
        
//        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(imageDataArray.count), height: UIScreen.main.bounds.width)
//        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(lastIndex ?? 5), height: UIScreen.main.bounds.width)
        
//        switch imageCount{
//
//            case 0:
//            cellimageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
//            imageScrollView.addSubview(cellimageView)
//        case 1:
//        cellimageView2.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
//        imageScrollView.addSubview(cellimageView2)
//        case 2:
//        cellimageView3.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
//        imageScrollView.addSubview(cellimageView3)
//        case 3:
//        cellimageView4.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
//        imageScrollView.addSubview(cellimageView4)
//        case 4:
//        cellimageView5.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
//        imageScrollView.addSubview(cellimageView5)
//
//            default:
//            break
//
//        }
        
        cellimageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
        cellimageView2.frame.origin.x = UIScreen.main.bounds.width * CGFloat(1)
        cellimageView3.frame.origin.x = UIScreen.main.bounds.width * CGFloat(2)
        cellimageView4.frame.origin.x = UIScreen.main.bounds.width * CGFloat(3)
        cellimageView5.frame.origin.x = UIScreen.main.bounds.width * CGFloat(4)

//        imageScrollView.addSubview(cellimageView)
//        imageScrollView.addSubview(cellimageView2)
//        imageScrollView.addSubview(cellimageView3)
//        imageScrollView.addSubview(cellimageView4)
//        imageScrollView.addSubview(cellimageView5)

        
//
//        for (index, imageName) in imageDataArray.enumerated() {
//            Storage.storage().reference().child(imageName).getData(maxSize: 1 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print(error)
//                }
//                else{
//                    let image = UIImage(data: data!)
//                    let imageView = UIImageView(image: image!)
//                    imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
//                    imageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(index)
//                    self.imageScrollView.addSubview(imageView)
//                }
//            }
//
//        }
        
        setLayoutConstraints()
    }//인터페이스 빌더를 사용하지 않아 초기화를 해주어야함
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    
   
    
    func setLayoutConstraints(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(writerLabel)
        contentView.addSubview(imageScrollView)
        contentView.addSubview(pageControl)
        
        
        //        self.addSubview(authImage)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(endDateLabel)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            
            writerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            writerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            
            
            imageScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            
            startDateLabel.topAnchor.constraint(equalTo: self.pageControl.bottomAnchor, constant: 10),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            
            endDateLabel.topAnchor.constraint(equalTo: self.startDateLabel.bottomAnchor, constant: 10),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            contentLabel.topAnchor.constraint(equalTo: self.endDateLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
        ])
        
        contentView.layer.cornerRadius = 3.0
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        
    }
}

extension GroupListCollectionViewCell: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(Float(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}

//extension GroupListCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return 3
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListImageCollectionViewCell", for: indexPath) as? GroupListImageCollectionViewCell else {return UICollectionViewCell()}
//
//        for i in urlDoubleArray{
//            print(i)
//            cell.imageView.kf.setImage(with: i[indexPath.row])
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: imageCollectionView.frame.width , height: imageCollectionView.frame.height)
//    }
//}









////
////  GroupListCollectionViewCell.swift
////  BlueCheck
////
////  Created by duck on 2023/02/22.
////
//
//import UIKit
//import FirebaseStorage
//import Kingfisher
//
//
//class GroupListCollectionViewCell: UICollectionViewCell{
//
//    static let identifier = "GroupListCollectionViewCell"
//
//
//    var imageArray: [GroupListTask] = []
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .darkGray
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let writerLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .systemBlue
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let startDateLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .systemRed
//        label.font = .systemFont(ofSize: 10, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    let endDateLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .systemBlue
//        label.font = .systemFont(ofSize: 10, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    let contentLabel: UILabel = {
//        let label = UILabel()
//
//        label.textColor = .darkGray
//        label.font = .systemFont(ofSize: 10, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    var imageCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//
//        layout.scrollDirection = .horizontal
////        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 100)
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .white
//        collectionView.register(GroupListImageCollectionViewCell.self, forCellWithReuseIdentifier: "GroupListImageCollectionViewCell")
//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//
//    let authImage: UIImageView = {
//        var imageView = UIImageView()
//        imageView.image = UIImage(systemName: "square")
//        imageView.backgroundColor = .systemBlue
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        return imageView
//    }()
//
//    var urlArray: [URL] = []
//    var urlDoubleArray: [[URL]] = [[]]
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setLayoutConstraints()
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
////        getFireStorage()
//
//        }
//
////    func getFireStorage(){
////        for i in imageArray{
////            Storage.storage().reference().child(i.image).listAll{ result , error in
////                if let error = error {
////                    print("ListAll 실패: \(error.localizedDescription)")
////                }
////                else{
////                    self.urlArray.removeAll()
////                    for item in result!.items{
////
////                        item.downloadURL { (url,error) in
////                            if let error = error {
////                                print("FireStorage Get Image Error : \(error.localizedDescription)")
////                            }
////                            else{
////                                guard let url = url else {return}
////                                self.urlArray.append(url)
////                            }
////
////                        }
////                    }
////                    self.urlDoubleArray.append(self.urlArray)
////                }
////
////            }
////        }
////    }
////
////
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//
//    func setLayoutConstraints(){
//        self.addSubview(titleLabel)
//        self.addSubview(writerLabel)
//        contentView.addSubview(imageCollectionView)
////        self.addSubview(authImage)
//        self.addSubview(startDateLabel)
//        self.addSubview(endDateLabel)
//        self.addSubview(contentLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//
//
//            writerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
//            writerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
//
//            imageCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 10),
//            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageCollectionView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
//
//
////            authImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 10),
////            authImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
////            authImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
////            authImage.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
////
//
//            startDateLabel.topAnchor.constraint(equalTo: self.imageCollectionView.bottomAnchor, constant: 10),
//            startDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//
//
//            endDateLabel.topAnchor.constraint(equalTo: self.startDateLabel.bottomAnchor, constant: 10),
//            endDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//
//            contentLabel.topAnchor.constraint(equalTo: self.endDateLabel.bottomAnchor, constant: 10),
//            contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
//
//        ])
//
//        contentView.layer.cornerRadius = 3.0
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.systemBlue.cgColor
//
//    }
//}
//
//extension GroupListCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return 3
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupListImageCollectionViewCell", for: indexPath) as? GroupListImageCollectionViewCell else {return UICollectionViewCell()}
//
//        for i in urlDoubleArray{
//            cell.imageView.kf.setImage(with: i[indexPath.row])
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: imageCollectionView.frame.width , height: imageCollectionView.frame.height)
//    }
//}
