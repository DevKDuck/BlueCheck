//
//  MyListTask.swift
//  BlueCheck
//
//  Created by duck on 2023/01/19.
//

import Foundation

struct MyCheckListTask: Codable{
    var title: String
    var content: String
    var importance: String
}


enum Importance: String{
    case veryImportant = "매우 중요"
    case important = "중요"
    case normal = "보통"
}
