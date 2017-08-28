//
//  TvpApiClass.swift
//  TVPage Player
//
//  Created by Dilip manek on 20/04/17.
//
//

import UIKit

public class TvpApiClass: NSObject {
    
    public class func VideoList(loginID:String,pageNumber:String,Max:String,orderBy:String,Order_direction:String,searchString:String,status:String, completion : ((NSArray,String)->())?) {
        
        var strURL = ("https://app.tvpage.com/api/videos?X-login-id=\(loginID)")
        strURL = pageNumber.characters.count > 0 ? "\(strURL)&p=\(pageNumber)" : strURL
        strURL = Max.characters.count > 0 ? "\(strURL)&n=\(Max)" : strURL
        strURL = orderBy.characters.count > 0 ? "\(strURL)&o=\(orderBy)" : strURL
        strURL = Order_direction.characters.count > 0 ? "\(strURL)&od=\(Order_direction)" : strURL
        strURL = searchString.characters.count > 0 ? "\(strURL)&s=\(searchString)" : strURL
        strURL = status.characters.count > 0 ? "\(strURL)&status=\(status)" : strURL
        
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    
    //Retrieves details from a specific video.
    public class func GetVideoDetails(LoginID:String,VideoID:String, completion : ((NSDictionary,String)->())?){
        
        let strURL = ("https://app.tvpage.com/api/videos/\(VideoID)?X-login-id=\(LoginID)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSDictionary() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSDictionary() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSDictionary() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    //Retrieves a list of channels that contain a specific video
    public class func GetVideoIdToChannels(LoginID:String,VideoID:String, completion : ((NSArray,String)->())?){
        
        let strURL = ("https://app.tvpage.com/api/videos/\(VideoID)/channels?X-login-id=\(LoginID)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    //Retrieves the products associated with a specific video
    public class func GetproductsOnVideo(LoginID:String,VideoID:String, completion : ((NSArray,String)->())?){
        let strURL = ("https://app.tvpage.com/api/videos/\(VideoID)/products?X-login-id=\(LoginID)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    
    
    //Retrieves the transcript text for a specific video.
    public class func GettranscriptOnVideo(LoginID:String,VideoID:String, completion : ((NSDictionary,String)->())?){
        
        let strURL = ("https://app.tvpage.com/api/videos/\(VideoID)/transcript?X-login-id=\(LoginID)")
        
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSDictionary() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSDictionary() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSDictionary() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    //Retrieves one or more videos that match a list of SKUs (referenceId).
    public class func Get_match_a_list_of_SKU_(LoginID:String,referenceIds:String, completion : ((NSDictionary,String)->())?){
        let strURL = ("https://app.tvpage.com/api/videos/referenceIds?X-login-id=\(LoginID)&ids=\(referenceIds)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSDictionary() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSDictionary() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSDictionary() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    //Searches videos.
    public class func Get_Searches_video_list(loginID:String,Searchstring:String,Pagenumber:String,Max:String,orderBy:String,Order_direction:String,channelsLimitIds:String, completion : ((NSArray,String)->())?){
        // https://app.tvpage.com/api/videos/search?X-login-id=1758929&s=Baahubali&p=0&n=20&o=title&od=DESC&channelsLimit=87486517,87486516
        var strURL = ("https://app.tvpage.com/api/videos/search?X-login-id=\(loginID)")
        strURL = Searchstring.characters.count > 0 ? "\(strURL)&s=\(Searchstring)" : strURL
        strURL = Pagenumber.characters.count > 0 ? "\(strURL)&p=\(Pagenumber)" : strURL
        strURL = Max.characters.count > 0 ? "\(strURL)&n=\(Max)" : strURL
        strURL = orderBy.characters.count > 0 ? "\(strURL)&o=\(orderBy)" : strURL
        strURL = Order_direction.characters.count > 0 ? "\(strURL)&od=\(Order_direction)" : strURL
        strURL = channelsLimitIds.characters.count > 0 ? "\(strURL)&channelsLimit=\(channelsLimitIds)" : strURL
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                            
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    //Retrieves a list of channels
    public class func ProductsList(loginID:String,pageNumber:String,Max:String,orderBy:String,Order_direction:String,searchString:String, completion : ((NSArray,String)->())?){
        // https://app.tvpage.com/api/products?X-login-id=1758929
        var strURL = ("https://app.tvpage.com/api/products?X-login-id=\(loginID)")
        strURL = pageNumber.characters.count > 0 ? "\(strURL)&p=\(pageNumber)" : strURL
        strURL = Max.characters.count > 0 ? "\(strURL)&n=\(Max)" : strURL
        strURL = orderBy.characters.count > 0 ? "\(strURL)&o=\(orderBy)" : strURL
        strURL = Order_direction.characters.count > 0 ? "\(strURL)&od=\(Order_direction)" : strURL
        strURL = searchString.characters.count > 0 ? "\(strURL)&s=\(searchString)" : strURL
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    
    
    //Retrieves details of a specific product.
    public class func Get_detail_Of_Product(LoginID:String,productsId:String, completion : ((NSDictionary,String)->())?){
        let strURL = ("https://app.tvpage.com/api/products/\(productsId)?X-login-id=\(LoginID)")
        
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSDictionary() , errorStr)
                                    return
                                }
                            }
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSDictionary() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSDictionary() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    //Retrieves a list of product-video recommendations.
    public class func Get_list_Of_Product_recommendations(LoginID:String,productsId:String,pageNumber:String,Max:String, completion : ((NSArray,String)->())?){
        var strURL = ("https://app.tvpage.com/api/products/\(productsId)/recommend/network?X-login-id=\(LoginID)")
        strURL = pageNumber.characters.count > 0 ? "\(strURL)&p=\(pageNumber)" : strURL
        strURL = Max.characters.count > 0 ? "\(strURL)&n=\(Max)" : strURL
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                        }
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    //Retrieves a list of videos associated with a specific product
    public class func Get_listOfVideo_SpecificProduct(LoginID:String,productsId:String, completion : ((NSArray,String)->())?){
        let strURL = ("https://app.tvpage.com/api/products/\(productsId)/videos?X-login-id=\(LoginID)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                        }
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    //Retrieves a list of channels
    public class func ChannelList(loginID:String,pageNumber:String,Max:String,orderBy:String,Order_direction:String,searchString:String, completion : ((NSArray,String)->())?) {
        
        var strURL = ("https://app.tvpage.com/api/channels?X-login-id=\(loginID)")
        strURL = pageNumber.characters.count > 0 ? "\(strURL)&p=\(pageNumber)" : strURL
        strURL = Max.characters.count > 0 ? "\(strURL)&n=\(Max)" : strURL
        strURL = orderBy.characters.count > 0 ? "\(strURL)&o=\(orderBy)" : strURL
        strURL = Order_direction.characters.count > 0 ? "\(strURL)&od=\(Order_direction)" : strURL
        strURL = searchString.characters.count > 0 ? "\(strURL)&s=\(searchString)" : strURL
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                        }
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
        
    }
    
    
    //GET /channels/{channelId}  Retrieves details of a specific channel.
    public class func GetChannelsDetails(strLoginID:String,strChhanelID:String, completion : ((NSDictionary,String)->())?){
        let strURL = ("https://app.tvpage.com/api/channels/\(strChhanelID)?X-login-id=\(strLoginID)")
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSDictionary() , errorStr)
                                    return
                                }
                            }
                        }
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    }else
                    {
                        if completion != nil {
                            
                            completion!(NSDictionary() , errorStr)
                        }
                    }
                    
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSDictionary() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    //Retrieve videos from a channel.
    //String to search.
    public class func ChannelVideoList(strLoginID:String,strChhanelID:String,searchString:String,pageNumber:Int,numberOfVideo:Int, completion : ((NSArray,String)->())?){
        
        var strURL = ("https://app.tvpage.com/api/channels/\(strChhanelID)/videos?X-login-id=\(strLoginID)&p=\(pageNumber)&n=\(numberOfVideo)")
        
        strURL = searchString.characters.count > 0 ? "\(strURL)&s=\(searchString)" : strURL
        let headers = [
            "cache-control": "no-cache",
            //            "postman-token": "d80700d9-44de-f252-e79f-103084d20a3a"
        ]
        
        //        let request = NSMutableURLRequest(url: NSURL(string: strURL)! as URL,
        //                                          cachePolicy: .useProtocolCachePolicy,
        //                                          timeoutInterval: 10.0)
        var request = URLRequest(url: NSURL(string: strURL)! as URL)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let  dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                var errorStr = ""
                if let bvar = error?.localizedDescription {
                    
                    errorStr = bvar
                }
                if data != nil && data!.count > 0{
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        if let strRespose = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            if (strRespose.caseInsensitiveCompare("null")) == .orderedSame || (strRespose.caseInsensitiveCompare("nil")) == .orderedSame{
                                if completion != nil {
                                    errorStr = strRespose as String
                                    completion!(NSArray() , errorStr)
                                    return
                                }
                            }
                        }
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        if completion != nil {
                            
                            completion!(json , errorStr)
                        }
                    } else {
                        
                        if completion != nil {
                            
                            completion!(NSArray() , errorStr)
                        }
                    }
                    
                } else {
                    
                    if completion != nil {
                        
                        completion!(NSArray() , errorStr)
                    }
                }
            }
        })
        dataTask.resume()
    }
}
