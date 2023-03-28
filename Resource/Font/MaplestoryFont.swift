//
//  MaplestoryFont.swift
//  BlueCheck
//
//  Created by duck on 2023/03/28.
//

import UIKit

extension UIFont{
    class func MaplestoryFont(type: MaplestoryType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }
    
    public enum MaplestoryType {
        case Bold
        case Light
        
        var name: String {
            switch self {
            case .Bold:
                return "MaplestoryOTFBold"
            case .Light:
                return "MaplestoryOTFLight"
            }
        }
    }
}
