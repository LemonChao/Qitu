//
//  InterfaceHeader.swift
//  Tibet
//
//  Created by zchao on 2019/7/19.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import Foundation

#if DEBUG
let AppBaseUrl = "http://qituapi-test.antnestintelligence.cc"
//let WebBaseUrl = "http://192.168.0.169:8888/#/"
let WebBaseUrl = "http://qituh5-test.antnestintelligence.cc/#/"

#else
let AppBaseUrl = "https://api.qituguoji.xyz"
let WebBaseUrl = "https://h5.qituguoji.xyz"

#endif

let updateVersion = AppBaseUrl + "/api/systeam/version"

