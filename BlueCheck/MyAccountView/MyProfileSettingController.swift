//
//  MyProfileSettingController.swift
//  BlueCheck
//
//  Created by duck on 2023/03/02.
//

import UIKit

class MyProfileSettingController: UIViewController{
    
    let profileImage: UIImage = {
        let image = UIImage()
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
