//
//  UpdateVersionModel.swift
//  Tibet
//
//  Created by zchao on 2019/7/17.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import SwiftyJSON

struct  UpdateVersionModel {
    var id: String!
    var name: String!
    var ver_no: String!
    var ver_nod: String!
    
    var type: String!
    var url: String!
    var force_update: Bool!
    var remark: String!

    
    init(jsonData: JSON) {
        id           = jsonData["id"].stringValue
        name         = jsonData["name"].stringValue
        ver_no       = jsonData["ver_no"].stringValue
        ver_nod      = jsonData["ver_nod"].stringValue
        url          = jsonData["url"].stringValue
        force_update = jsonData["force_update"].boolValue
        remark       = jsonData["remark"].stringValue
    }
    
}
