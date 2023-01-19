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
}

struct MyCheckListTaskArray: Codable{
    var myCheckListTaskArray: [MyCheckListTask]
}
