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


class EachGroupRecordsTableViewCell: UITableViewCell{
    
    static let identifier = "EachGroupRecordsTableViewCell"
    
    
    var imageArray: [GroupListTask] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(tapModifyButton(_:)), for: .touchUpInside)
        return button
    }()
    
//    @objc func tapModifyButton(_ sender: UIButton){
//        let alert = UIAlertController(title: "글을 관리할 수 있습니다.", message: "글관리 가능", preferredStyle: .actionSheet)
//        
//        let delete = UIAlertAction(title: "삭제하기", style: .default){ _ in
//            print("삭제완료")
//            
//        }
//        
//        let modify = UIAlertAction(title: "수정하기", style: .default){ _ in
//            let modifyVC = CreateEachGroupRecordsContentViewController()
//            
//            print("수정완료")
//            
//        }
//        
//        let cancel = UIAlertAction(title: "취소", style: .cancel)
//        
//        alert.addAction(delete)
//        alert.addAction(modify)
//        alert.addAction(cancel)
//        
//        self.present(alert)
//        
//    }
    
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let cellimageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let cellimageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let cellimageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let cellimageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var lastIndex: Int?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageScrollView.delegate = self
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray // 페이지를 암시하는 동그란 점의 색상
        pageControl.currentPageIndicatorTintColor = .systemBlue // 현재 페이지를 암시하는 동그란 점 색상
        
        
        cellimageView.frame.origin.x = UIScreen.main.bounds.width * CGFloat(0)
        cellimageView2.frame.origin.x = UIScreen.main.bounds.width * CGFloat(1)
        cellimageView3.frame.origin.x = UIScreen.main.bounds.width * CGFloat(2)
        cellimageView4.frame.origin.x = UIScreen.main.bounds.width * CGFloat(3)
        cellimageView5.frame.origin.x = UIScreen.main.bounds.width * CGFloat(4)


        
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
        contentView.addSubview(modifyButton)
        
        
        //        self.addSubview(authImage)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(endDateLabel)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7),
            
            
            writerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            writerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            
            
            imageScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10),
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            pageControl.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            modifyButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
            modifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            modifyButton.widthAnchor.constraint(equalToConstant: 44),
            modifyButton.heightAnchor.constraint(equalToConstant: 44),
            
            
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

extension EachGroupRecordsTableViewCell: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(Float(scrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
