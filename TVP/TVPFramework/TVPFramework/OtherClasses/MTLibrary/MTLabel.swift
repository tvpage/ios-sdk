//
//  MTLabel.swift
//  HomeEscape
//
//  Created by  on 8/17/17.
//  Copyright © . All rights reserved.
//

import UIKit


//MARK: - MTLabel
class MTLabel : UILabel {
    override func awakeFromNib() {
        
        if (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO) {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
            
        } else {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
            //Font size auto resizing in different devices
            self.font = self.font.withSize((self.font.pointSize * DeviceScale.x))
        }
    }
}
