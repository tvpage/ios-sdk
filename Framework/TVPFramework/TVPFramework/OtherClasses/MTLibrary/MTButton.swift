//
//  MTButton.swift
//  HomeEscape
//
//  Created by  on 8/21/17.
//  Copyright © . All rights reserved.
//

import UIKit

class MTButton: UIButton {

    override func awakeFromNib() {
        
        if (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO) {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
            
        } else {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
            //Font size auto resizing in different devices
            
            self.titleLabel?.font = self.titleLabel?.font.withSize(((self.titleLabel?.font.pointSize)! * DeviceScale.x))
            
        }
    }
}
