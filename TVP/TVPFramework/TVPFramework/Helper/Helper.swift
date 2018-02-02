

import UIKit

//MARK: - Constant Declaration
struct Constants {
    
    //Base URL
    static let baseURL = "https://app.tvpage.com/api/"
    
    //Global Login id and Channel id
    static let loginID = "1758799"
    static let channelID = "66133905"
    static let productID = "83102606"
    static var videoPageNumber = 0
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

//MARK: - Scaling
struct DeviceScale {
    
    static let x = ScreenSize.width / 375.0
    static let y = ScreenSize.height / 667.0
    static let xy = (DeviceScale.x + DeviceScale.y) / 2.0
    
    static let x_iPhone:Float = (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO ? Float(1.0) : Float(ScreenSize.width / 375.0))
    static let y_iPhone:Float = (DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO ? Float(1.0) : Float(ScreenSize.height / 667.0))
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
    
    static let DosisRegular = "Dosis-Regular"
    static let DosisBold = "Dosis-Bold"
    static let DosisMedium = "Dosis-Medium"
    static let DosisSemiBold = "Dosis-SemiBold"
    static let DosisLight = "Dosis-ExtraLight"
    static let DosisExtraLight = "Dosis-ExtraLight"
    static let DosisExtraBold = "Dosis-ExtraBold"
}

//MARK: - Get Storyboard for video gallery
public func getStoryboard() -> UIStoryboard {
    
    let  bundle = Bundle(url: Bundle.main.url(forResource: "TVPResources", withExtension: "bundle")!)
    let  storyboardPath: String? = bundle?.path(forResource: "VideoGallery", ofType: "storyboard")
    let frameworkBundle = Bundle(path: storyboardPath!)
    let storyboard = UIStoryboard(name: "VideoGallery", bundle: frameworkBundle)
    return storyboard
}
public func getVideoGalleryVC() -> VideoGalleryVC {
    
    let storyboard = getStoryboard()
    let videoGallery = storyboard.instantiateViewController(withIdentifier: "VideoGalleryVC") as! VideoGalleryVC
    return videoGallery
}
