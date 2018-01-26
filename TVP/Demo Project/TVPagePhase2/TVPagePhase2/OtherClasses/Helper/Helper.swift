//
//  Helper.swift
//  CommonClass
//
//  Created by  on 5/2/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SystemConfiguration

//MARK: - AppDelagate Object
@available(iOS 10.0, *)
var appDelegateShared = UIApplication.shared.delegate as! AppDelegate

//MARK: - Web Services Constant
struct WebURL {
    
    //Google place API key
    static let googlePlaceAPIKey:String = ""
    
    //iOS Token Key and Value
    static let tokenKey:String = "Authorization"
    static let tokenValue:String = ""
    
    //Development baseURL
    static let baseURL:String = ""
    
    //API URL Listing
    static let search:String = ""
}

//MARK: - Device Type
enum UIUserInterfaceIdiom : Int {
    
    case Unspecified
    case Phone
    case Pad
}
struct DeviceType {
    
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6PLUS         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

//MARK: - Screen Size
struct ScreenSize {
    
    static let width         = UIScreen.main.bounds.size.width
    static let height        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.width, ScreenSize.height)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.width, ScreenSize.height)
}

//MARK: - Font Layout
struct FontName {
    
    //Font Name List
    static let HelveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    static let HelveticaNeueLight = "HelveticaNeue-Light"
    static let HelveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    static let HelveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    static let HelveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    static let HelveticaNeueThin = "HelveticaNeue-Thin"
    static let HelveticaNeueMedium = "HelveticaNeue-Medium"
    static let HelveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    static let HelveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    static let HelveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    static let HelveticaNeueBold = "HelveticaNeue-Bold"
    static let HelveticaNeue = "HelveticaNeue"
    static let HelveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    static let SatteliteRegular = "Satellite"
    static let SatteliteOblique = "Satellite-Oblique"
}

func setFontLayout(strFontName:String,fontSize:CGFloat) -> UIFont {
    
    //Set auto font size in different devices.
    return UIFont(name: strFontName, size: (ScreenSize.width / 375) * fontSize)!
}
//MARK: - Set Color Method
func getColor(r: Float, g: Float, b: Float, aplha: Float)-> UIColor {
    
  return UIColor(red: CGFloat(Float(r / 255.0)), green: CGFloat(Float(g / 255.0)) , blue: CGFloat(Float(b / 255.0)), alpha: CGFloat(aplha))
}

//MARK: - Scaling
struct DeviceScale {
    
    static let x = ScreenSize.width / 375.0
    static let y = ScreenSize.height / 667.0
    static let xy = (DeviceScale.x + DeviceScale.y) / 2.0
    
    static let x_iPhone:Float = (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO ? Float(1.0) : Float(ScreenSize.width / 375.0))
    static let y_iPhone:Float = (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO ? Float(1.0) : Float(ScreenSize.height / 667.0))
}

//MARK: - Helper Class
class Helper {
//MARK: - Shared Instance
    static let sharedInstance : Helper = {
        let instance = Helper()
        return instance
    }()

    static let isDevelopmentBuild:Bool = true
 
}
@objc public class Hello: NSObject {
    func sayHello() {
        print("Hi there!")
    }
}
//MARK: - Create thumbnail image
func smallImageWithImage(sourceImage: UIImage) -> UIImage {
    var width:Int = 0
    var height:Int = 0
    let y = sourceImage.size.height
    let x = sourceImage.size.width
    
    if sourceImage.size.height > 175 || sourceImage.size.width > 175 {
        if sourceImage.size.height > sourceImage.size.width {
            height = 175
            width = 0
        }else {
            height = 0
            width = 175
        }
    }
    
    var factor:Double = 1.0
    if width > 0 {
        factor = (Double(width) / Double(x) ) as Double
    }
    else if height > 0 {
        factor = Double(height) / Double(y)
    }
    
    let newheight = Double(y) * factor
    let newwidth = Double(x) * factor
    
    UIGraphicsBeginImageContext(CGSize(width : CGFloat(newwidth),height :  CGFloat(newheight)))
    sourceImage.draw(in: CGRect(x : 0,y : 0,width : CGFloat(newwidth),height : CGFloat(newheight)))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

//MARK: - Protocol Oriented Programming Language
protocol Shakeable { }

extension Shakeable where Self: UIView {
    
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 4.0, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 4.0, y:self.center.y))
        layer.add(animation, forKey: "position")
    }
}
class MTImageView: UIImageView, Shakeable {
    
}
