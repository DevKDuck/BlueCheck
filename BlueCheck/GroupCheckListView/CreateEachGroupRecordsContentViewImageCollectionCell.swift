//
//  CreateEachGroupRecordsContentViewImageCollectionCell.swift
//  BlueCheck
//
//  Created by duck on 2023/03/04.
//

import UIKit

class CreateEachGroupRecordsContentViewImageCollectionCell: UICollectionViewCell{
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayoutConstraints()

    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLayoutConstraints() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
