//
//  GroupListImageCollectionView.swift
//  BlueCheck
//
//  Created by duck on 2023/03/04.
//

import UIKit

class GroupListImageCollectionViewCell: UICollectionViewCell{
    
    static let identifer = "GroupListImageCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraint()
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLayoutConstraint(){
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
}
