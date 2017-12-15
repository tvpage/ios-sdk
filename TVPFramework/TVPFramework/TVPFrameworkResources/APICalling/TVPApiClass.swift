//
//  TvpApiClass.swift
//  TVPage Player
//


import UIKit

public class TVPApiClass: NSObject {
    
    //MARK: - Retrieve videos from a channel.
    public class func channelVideoList(strLoginID:String,strChhanelID:String,searchString:String,pageNumber:Int,numberOfVideo:Int, completion : ((NSArray,String)->())?){
        
        var strURL = ("\(Constants.baseURL)channels/\(strChhanelID)/videos?X-login-id=\(strLoginID)&p=\(pageNumber)&n=\(numberOfVideo)")
        
        strURL = searchString.characters.count > 0 ? "\(strURL)&s=\(searchString)" : strURL
        let headers = [
            "cache-control": "no-cache",
        ]
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
                if data != nil {
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        
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
    //MARK: - Retrieves the products associated with a specific video
    public class func getProductsOnVideo(loginID:String,videoID:String, completion : ((NSArray,String)->())?){
        let strURL = ("https://app.tvpage.com/api/videos/\(videoID)/products?X-login-id=\(loginID)")
        let headers = [
            "cache-control": "no-cache"
        ]
        
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
                if data != nil {
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200
                    {
                        
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
}
