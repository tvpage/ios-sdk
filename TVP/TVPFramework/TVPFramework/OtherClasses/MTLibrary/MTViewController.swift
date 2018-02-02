//
//  MTViewController.swift
//  HomeEscape
//
//  Created by  on 8/17/17.
//  Copyright © . All rights reserved.
//

import UIKit

//MARK: - MTViewController
public class MTViewController : UIViewController {
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
    @IBOutlet var arrVerticalConstraint : [NSLayoutConstraint]!
    @IBOutlet var arrHorizontalConstraint : [NSLayoutConstraint]!
    
    //Outlet for auto resizing constraint constant set in different devices
    //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
    @IBOutlet var arrVerticalConstraint_iPad : [NSLayoutConstraint]!
    @IBOutlet var arrHorizontalConstraint_iPad : [NSLayoutConstraint]!
    
    //Outlet for auto resizing constraint constant set in different devices
    @IBOutlet var arrConstraint : [NSLayoutConstraint]!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO) {
            
            //iPad and iPadPro device
            
        } else {
            
            //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus
            if arrVerticalConstraint != nil {
                
                //Auto resizing verticat constraint constant set in different devices
                for const in arrVerticalConstraint {
                    const.constant = const.constant * DeviceScale.y
                }
            }
            
            if arrHorizontalConstraint != nil {
                
                //Auto resizing horozontal constraint constant set in different devices
                for const in arrHorizontalConstraint {
                    const.constant = const.constant * DeviceScale.x
                }
            }
            
            if arrConstraint != nil {
                
                //Auto resizing constraint constant set in different devices
                for const in arrConstraint {
                    
                    const.constant = const.constant * DeviceScale.x
                }
            }
        }
        
        //iPhone4 , iPhone5 , iPhone6 , iPhone6Plus , iPad and iPadPro device
        if arrVerticalConstraint_iPad != nil {
            
            //Auto resizing vertical constraint constant set in different devices
            for const in arrVerticalConstraint_iPad {
                const.constant = const.constant * DeviceScale.y
            }
        }
        
        if arrHorizontalConstraint_iPad != nil {
            
            //Auto resizing horizontal constraint constant set in different devices
            for const in arrHorizontalConstraint_iPad {
                const.constant = const.constant * DeviceScale.x
            }
        }
    }
}
