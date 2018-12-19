//
//  MTCollectionCell.swift
//  HomeEscape
//
//  Created by  on 8/17/17.
//  Copyright © . All rights reserved.
//

import UIKit

//MARK: - MTCollectionCell
class MTCollectionCell: UICollectionViewCell {
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
    @IBOutlet var arrCollCellVerticalConstraint : [NSLayoutConstraint]!
    @IBOutlet var arrCollCellHorizontalConstraint : [NSLayoutConstraint]!
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
    @IBOutlet var arrCollCellVerticalConstraint_iPad : [NSLayoutConstraint]!
    @IBOutlet var arrCollCellHorizontalConstraint_iPad : [NSLayoutConstraint]!
    
    @IBOutlet var arrCellConstants: [NSLayoutConstraint]!
    
    override func awakeFromNib() {
        
        if (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO) {
            
            //iPad and iPadPro device
            
        } else {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
            if arrCollCellVerticalConstraint != nil {
            
                //Auto resizing verticat constraint constant set in different devices
                for const in arrCollCellVerticalConstraint {
                    const.constant = const.constant * DeviceScale.y
                }
            }
            
            if arrCollCellHorizontalConstraint != nil {
                
                //Auto resizing horozontal constraint constant set in different devices
                for const in arrCollCellHorizontalConstraint {
                    const.constant = const.constant * DeviceScale.x
                }
            }
            
            if arrCellConstants != nil {
                
                for const in arrCellConstants {
                    const.constant = const.constant * DeviceScale.x
                }
            }
        }
        
        //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
        if arrCollCellVerticalConstraint_iPad != nil {
        
            //Auto resizing vertical constraint constant set in different devices
            for const in arrCollCellVerticalConstraint_iPad {
                const.constant = const.constant * DeviceScale.y
            }
        }
        
        if arrCollCellHorizontalConstraint_iPad != nil {
            
            //Auto resizing horizontal constraint constant set in different devices
            for const in arrCollCellHorizontalConstraint_iPad {
                const.constant = const.constant * DeviceScale.x
            }
        }
    }
}
