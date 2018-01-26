//
//  UserInfo.swift
//  TrackMyPocket
//
//  Created by  on 7/4/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

class UserInfo {
    
    //MARK: - Shared Instance
    static let sharedInstance : UserInfo = {
        let instance = UserInfo()
        return instance
    }()
    
    //MARK: - Set and Get Login Status
    func isUserLogin() -> Bool {
        
        if let strLoginStatus:Bool = UserDefaults.standard.bool(forKey: "login") as Bool? {
            let status:Bool = strLoginStatus
            if  status == true {
                return true
            }
        }
        return false
    }
    func isUserLogin(isLogin:Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "login")
        UserDefaults.standard.synchronize()
    }
    //MARK: - Set and Get Logined user details
    func getUserInfo(key: String) -> String {
        
        if let dictUserInfo:NSDictionary = UserDefaults.standard.dictionary(forKey: "Userdata") as NSDictionary? {
            print("Userdata : ",dictUserInfo)
            if let strValue = dictUserInfo.value(forKey: key) {
                return "\(strValue)"
            }
        }
        return ""
    }
    func setUserInfo(dictData: NSDictionary) {
        
        UserDefaults.standard.set(dictData, forKey: "Userdata")
        UserDefaults.standard.synchronize()
    }
}
