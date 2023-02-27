//
//  GroupListTask.swift
//  BlueCheck
//
//  Created by duck on 2023/02/22.
//

import Foundation

struct GroupListTask: Codable{
    var title: String
    var startDate: String
    var endDate: String
    var content: String
    var image: String
    var writer: String
}


struct InviteListTask: Codable{
    var content: String
    var groupName: String
    var groupNumber: String
    var object: String
    var status: String
}
