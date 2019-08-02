//
//  InterfaceHeader.swift
//  Tibet
//
//  Created by zchao on 2019/7/19.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import Foundation

#if DEBUG
let AppBaseUrl = "http://xoj.rzl8y.com"
//let WebBaseUrl = "http://192.168.0.222:8080/#/"
let WebBaseUrl = "http://xoj.rzl8y.com/web"

#else
let AppBaseUrl = "http://xoj.rzl8y.com"
let WebBaseUrl = "http://xoj.rzl8y.com/web"

#endif

let updateVersion = AppBaseUrl + "/api/version/getVersion"

