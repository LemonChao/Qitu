//
//  SystemHeader.swift
//  Tibet
//
//  Created by zchao on 2019/7/17.
//  Copyright © 2019 Leyukeji. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import SwiftyJSON


//获取沙盒Document路径
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//获取沙盒Cache路径
let kCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
//获取沙盒temp路径
let kTempPath = NSTemporaryDirectory()

//颜色
func RGBA(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}

func HexColor(_ HexString: String) ->UIColor {
    return UIColor.colorWith(hexString: HexString)
}



//开发的时候打印，但是发布的时候不打印,使用方法，输入print(message: "输入")
func print<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    // 要把路径最后的字符串截取出来
    let lastName = ((fileName as NSString).pathComponents.last!)
    print("\(dformatter.string(from: now)) [\(lastName)][第\(lineNumber)行] \n\t\t \(message)")
    #endif
}

// UserDefaults 操作
let kUserDefaults = UserDefaults.standard
func kUserDefaultsRead(_ KeyStr: String) -> String {
    return kUserDefaults.string(forKey: KeyStr)!
}
func kUserDefaultsWrite(_ obj: Any, _ KeyStr: String) {
    kUserDefaults.set(obj, forKey: KeyStr)
}
func kUserValue(_ A: String) -> Any? {
    return kUserDefaults.value(forKey: A)
}

//获取屏幕大小
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

func FitWidth(_ width: CGFloat) -> CGFloat {
    return width / 375 * SCREEN_WIDTH
}

func FitHeight(_ height: CGFloat) -> CGFloat {
    return height / 667 * SCREEN_HEIGHT

}

//APP 名字
let AppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
//APP版本号
let AppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//当前系统版本号
let SystemVersion = UIDevice.current.systemVersion





//获取当前语言
let kAppCurrentLanguage = Locale.preferredLanguages[0]
//判断是否为iPhone
let kDeviceIsiPhone = (UI_USER_INTERFACE_IDIOM() == .phone)
//判断是否为iPad
let kDeviceIsiPad = (UI_USER_INTERFACE_IDIOM() == .pad)

/// 机型判断
let kiPhone5 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)

let kiPhone6 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)

let kiPhone6Plus =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)

let kiPhone6Plus_Scale =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2001).equalTo((UIScreen.main.currentMode?.size)!) : false)

/// iPhone X, iPhone XS
let IS_IPHONE_X =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE_Xr =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 828, height: 1792).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE_XsMax =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2688).equalTo((UIScreen.main.currentMode?.size)!) : false)

/// iPhoneX系列
let kiPhoneX = (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_XsMax)

//获取状态栏高度
let StatusBarHeight     = (kiPhoneX ? 44.0 : 20.0)
//获取导航栏高度
let NavBarHeight        = (kiPhoneX ? 88.0 : 64.0)
//获取tabBar高度
let TabBarHeight        = (kiPhoneX ? 83.0 : 49.0)
//获取虚拟home键高度
let IndicatorHomeHeight = (kiPhoneX ? 34.0 : 0.0)

// 注册通知
func kNOTIFY_ADD(observer: Any, selector: Selector, name: String) {
    return NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(rawValue: name), object: nil)
}
// 发送通知
func kNOTIFY_POST(name: String, object: Any) {
    return NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object)
}
// 移除通知
func kNOTIFY_REMOVE(observer: Any, name: String) {
    return NotificationCenter.default.removeObserver(observer, name: Notification.Name(rawValue: name), object: nil)
}

//代码缩写
let kApplication = UIApplication.shared
let kAPPKeyWindow = kApplication.keyWindow
let kAppDelegate = kApplication.delegate
let kAppNotificationCenter = NotificationCenter.default
let kAppRootViewController = kAppDelegate?.window??.rootViewController

//字体 字号
func kFontSize(_ a: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: a)
}
func kFontBoldSize(_ a: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: a)
}
func kFontForIPhone5or6Size(_ a: CGFloat, _ b: CGFloat) -> UIFont {
    return kiPhone5 ? kFontSize(a) : kFontSize(b)
}

/**
 字符串是否为空
 @param str NSString 类型 和 子类
 @return  BOOL类型 true or false
 */
func kStringIsEmpty(_ str: String!) -> Bool {
    if str.isEmpty {
        return true
    }
    if str == nil {
        return true
    }
    if str.count < 1 {
        return true
    }
    if str == "(null)" {
        return true
    }
    if str == "null" {
        return true
    }
    return false
}
// 字符串判空 如果为空返回@“”
func kStringNullToempty(_ str: String) -> String {
    let resutl = kStringIsEmpty(str) ? "" : str
    return resutl
}
func kStringNullToReplaceStr(_ str: String,_ replaceStr: String) -> String {
    let resutl = kStringIsEmpty(str) ? replaceStr : str
    return resutl
}

/**
 数组是否为空
 @param array NSArray 类型 和 子类
 @return BOOL类型 true or false
 */
func kArrayIsEmpty(_ array: [String]) -> Bool {
    let str: String! = array.joined(separator: "")
    if str == nil {
        return true
    }
    if str == "(null)" {
        return true
    }
    if array.count == 0 {
        return true
    }
    if array.isEmpty {
        return true
    }
    return false
}
/**
 字典是否为空
 @param dic NSDictionary 类型 和子类
 @return BOOL类型 true or false
 */
func kDictIsEmpty(_ dict: NSDictionary) -> Bool {
    let str: String! = "\(dict)"
    if str == nil {
        return true
    }
    if str == "(null)" {
        return true
    }
    if dict .isKind(of: NSNull.self) {
        return true
    }
    if dict.allKeys.count == 0 {
        return true
    }
    return false
}


