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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        contentView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
        
        cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor),
        cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        cancelButton.heightAnchor.constraint(equalToConstant: 44),
        cancelButton.widthAnchor.constraint(equalToConstant: 44)
        
        ])
    }
}
