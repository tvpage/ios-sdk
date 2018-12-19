//
//  MTTableCell.swift
//  HomeEscape
//
//  Created by  on 8/17/17.
//  Copyright © . All rights reserved.
//

import UIKit

//MARK: - MTTableCell
class MTTableCell: UITableViewCell {
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
    @IBOutlet var arrTableCellVerticalConstraint : [NSLayoutConstraint]!
    @IBOutlet var arrTableCellHorizontalConstraint : [NSLayoutConstraint]!
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
    @IBOutlet var arrTableCellVerticalConstraint_iPad : [NSLayoutConstraint]!
    @IBOutlet var arrTableCellHorizontalConstraint_iPad : [NSLayoutConstraint]!
    
    @IBOutlet var arrTableCellConstants: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        
        if (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO) {
         
            //iPad and iPadPro device
            
        } else {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
            if arrTableCellVerticalConstraint != nil {
            
                //Auto resizing verticat constraint constant set in different devices
                for const in arrTableCellVerticalConstraint {
                    const.constant = const.constant * DeviceScale.y
                }
            }
            
            if arrTableCellHorizontalConstraint != nil {
                
                //Auto resizing horozontal constraint constant set in different devices
                for const in arrTableCellHorizontalConstraint {
                    const.constant = const.constant * DeviceScale.x
                }
            }
            
            if arrTableCellConstants != nil {
                
                for const in arrTableCellConstants {
                    const.constant = const.constant * DeviceScale.x
                }
            }
        }
        
        //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
        if arrTableCellVerticalConstraint_iPad != nil {
        
            //Auto resizing vertical constraint constant set in different devices
            for const in arrTableCellVerticalConstraint_iPad {
                const.constant = const.constant * DeviceScale.y
            }
        }
        
        if arrTableCellHorizontalConstraint_iPad != nil {
        
            //Auto resizing horizontal constraint constant set in different devices
            for const in arrTableCellHorizontalConstraint_iPad {
                const.constant = const.constant * DeviceScale.x
            }
        }
    }
}
