//
//  ProgressHud.swift
//  TVPagePhase2
//
//  Created by Dilip Manek on 1/29/18.
//  Copyright © 2018 Dilip Manek. All rights reserved.
//

import UIKit

func showHud(){
    SVProgressHUD.setDefaultAnimationType(.flat)
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.setBackgroundColor(UIColor.init(red: 44.0/255.0, green: 99.0/255.0, blue: 115.0/255.0, alpha: 1.0))
    SVProgressHUD.setForegroundColor(UIColor.white)
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.show()
}
func dismissHud(){
    SVProgressHUD.dismiss()
}
var HUD: MBProgressHUD!
func showToastMessage(message:NSString) -> Void{
    HUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
    
    HUD?.mode = MBProgressHUDModeText
    HUD?.labelText = message as String!
    HUD?.yOffset = 200.0
    HUD?.dimBackground = true
    HUD?.sizeToFit()
    HUD?.color = UIColor.init(red: 44.0/255.0, green: 99.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    HUD?.margin = 10.0
    HUD?.removeFromSuperViewOnHide = true
    HUD?.hide(true, afterDelay: 2.0)
}
